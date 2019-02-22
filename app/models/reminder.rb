class Reminder < ApplicationRecord
  belongs_to :creator, :class_name => 'User'
  belongs_to :caller,  :class_name => 'User', optional: true

  validates :title,            presence: true
  validates :status,           presence: true
  validates :public,           presence: true
  validates :creator,          presence: true
  validates :will_trigger_at,  presence: true

  validate :valid_trigger_time?

  def send_reminder!
    # send the reminder
    reminding_user = User.in_reminder_lobby.first
    puts reminding_user.present?
    if reminding_user.present?
      msg = {}
      msg['reminder'] = self.to_json
      msg['user'] = self.creator.to_json
      UserChannel.broadcast_to(reminding_user, msg)
      reminding_user.leave_reminder_lobby
      self.status = "triggered"
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

  def triggered?
    status == "triggered"
  end
end
