class Reminder < ApplicationRecord
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
    # send the reminder
    if self.push && creator.device_token.present?
      # send push notification
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name("poke_ios")
      n.device_token = creator.device_token
      n.alert = "Don't forget! #{self.title}"
      n.data = self.as_json
      n.save!
      return
    end
    reminding_user = User.in_reminder_lobby(creator).first
    puts reminding_user.present?
    if reminding_user.present?
      msg = {}
      msg['phone_number'] = self.creator.phone_number
      msg['title'] = self.title
      msg['time'] = self.will_trigger_at
      msg['name'] = self.creator.name
      UserChannel.broadcast_to(reminding_user, msg.to_json)
      reminding_user.leave_reminder_lobby
      self.status = "triggered"
      self.caller = reminding_user
      self.triggered_at = Time.now
      self.save
    else
      # push notification
    end

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
