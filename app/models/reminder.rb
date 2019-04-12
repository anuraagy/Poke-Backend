class Reminder < ApplicationRecord
  include TwilioHelper
  include RpushHelper

  has_many :comments
  has_many :likes
  
  belongs_to :creator, class_name: 'User'
  belongs_to :caller,  class_name: 'User', optional: true
  belongs_to :friend,  class_name: 'User', optional: true

  validates :title,            presence: true
  validates :status,           presence: true
  validates :creator,          presence: true
  validates :will_trigger_at,  presence: true
  validates_inclusion_of :public     , in: [true, false]
  validates_inclusion_of :push       , in: [true, false]
  validates_inclusion_of :automated  , in: [true, false]

  validate :valid_trigger_time?
  validate :valid_push_user?
  validate :valid_reminder_type?

  def send_reminder!
    #check for push notification
    if self.push && creator.device_token.present?
      push_notification("Don't forget! #{self.title}")
      return
    end

    if self.automated
      TwilioHelper::automated_call(self)
      update(status: 'triggered')
      return
    end

    if friend.present?
      n = Rpush::Apns::Notification.new
      n.app = RpushHelper::app
      n.device_token = friend.device_token
      n.alert = "Don't forget to remind your friend #{creator.name} about their reminder,"\
                "\"#{title}\""
      data = {}
      data['type'] = 'friend_reminder'
      data['phone_number'] = creator.phone_number
      data['reminder'] = self.as_json
      n.data = data
      n.save!
      update(status: 'triggered')
      return
    end

    reminding_user = User.in_reminder_lobby(creator).first
    # normal notification, get next user on top of queue
    if reminding_user.present?
      #create twilio proxy session to mask number
      masked_numer = self.creator.phone_number
      if ENV.key?('MASKING_ENABLED')
        session = TwilioHelper::create_proxy_session
        self.update(proxy_session_sid: session.sid)
        TwilioHelper::add_participant(session.sid, creator)
        participant = TwilioHelper::add_participant(session.sid, reminding_user)
        masked_numer = participant.proxy_identifier
        Delayed::Job.enqueue(
          ReminderBackupJob.new(id),
          0,
          Time.now + 3.minutes + 30.seconds
        )
      end
      # return calling info to reminder user through actioncable
      msg = {}
      msg['phone_number'] = masked_numer
      msg['title'] = self.title
      msg['time'] = self.will_trigger_at
      msg['name'] = self.creator.name
      UserChannel.broadcast_to(reminding_user, msg.to_json)
      reminding_user.leave_reminder_lobby
      self.status = "triggered"
      self.caller = reminding_user
      self.triggered_at = Time.now
      self.save
    elsif creator.device_token.present?
      # no one in queue, send a push notification if we can.
      push_notification("Sorry, no one was around to remind you! #{self.title}")
    end
  end

  def send_backup_reminder
    if !self.did_proxy_interact
      self.caller = nil
      self.push = true
      push_notification("Sorry, no one was around to remind you! #{self.title}") 
    end
  end

  def push_notification(alert)
    return if Rails.env.test?
    n = Rpush::Apns::Notification.new
    n.app = RpushHelper::app
    n.device_token = creator.device_token
    n.alert = alert
    data = {}
    data['type'] = 'reminder'
    data['reminder'] = self.as_json
    n.data = data
    n.save!
    update(status: 'triggered')
  end

  def valid_trigger_time?
    #if will_trigger_at.present? && will_trigger_at < Time.now + 5.minutes
    #  errors.add(:will_trigger_at, "Has to be at least 5 minutes in the future")
    #end
  end

  def valid_reminder_type?
    if push && (automated || friend.present?)
      errors.add(:push, "cannot have more than one of push, automated, and friend set")
    elsif automated && (push || friend.present?)
      errors.add(:push, "cannot have more than one of push, automated, and friend set")
    elsif friend.present? && (automated || push)
      errors.add(:push, "cannot have more than one of push, automated, and friend set")
    end
  end

  def valid_push_user?
    if push && !creator.device_token.present?
      errors.add(:push, "User does not have push notifications on")
    end
  end

  def triggered?
    status == "triggered"
  end
end
