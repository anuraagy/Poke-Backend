class Reminder < ApplicationRecord
  include TwilioHelper

  has_many :comments
  has_many :likes
  
  belongs_to :creator, :class_name => 'User'
  belongs_to :caller,  :class_name => 'User', optional: true

  validates :title,            presence: true
  validates :status,           presence: true
  validates :creator,          presence: true
  validates :will_trigger_at,  presence: true
  validates_inclusion_of :public, in: [true, false]
  validates_inclusion_of :push  , in: [true, false]

  validate :valid_trigger_time?
  validate :valid_push_user?

  def send_reminder!
    #check for push notification
    if self.push && creator.device_token.present?
      push_notification("Don't forget! #{self.title}")
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
    n.app = Rpush::Apns::App.find_by_name('poke_ios')
    if n.app.nil?
      apns_file = File.join(Rails.root, 'development.pem')
      n.app = Rpush::Apns::App.new
      n.app.name = 'poke_ios'
      n.app.certificate = File.read(apns_file)
      n.app.environment = 'development' # APNs environment.
      n.app.password = '' #Rails.application.credentials.apns_cert_pw
      n.app.connections = 1
      n.app.save!
    end
    n.device_token = creator.device_token
    n.alert = alert
    n.data = self.as_json
    n.save!
  end

  def valid_trigger_time?
    #if will_trigger_at.present? && will_trigger_at < Time.now + 5.minutes
    #  errors.add(:will_trigger_at, "Has to be at least 5 minutes in the future")
    #end
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
