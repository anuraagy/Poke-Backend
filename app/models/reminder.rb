class Reminder < ApplicationRecord
  belongs_to :creator, :class_name => 'User'
  belongs_to :caller,  :class_name => 'User'

  validates :description,      presence: true
  validates :status,           presence: true
  validates :public,           presence: true
  validates :creator,          presence: true
  valdiates :will_trigger_at,  presence: true

  validate :valid_trigger_time?


  def valid_trigger_time?
    if will_trigger_at < Time.now + 5.minutes
      errors.add(:will_trigger_at, "Has to be at least 5 minutes in the future")
    end
  end

  def triggered?
    status == "triggered"
  end
end
