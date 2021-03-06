class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :friend_requests_sent,     foreign_key: "sender_id",   class_name: "FriendRequest"
  has_many :friend_requests_received, foreign_key: "receiver_id", class_name: "FriendRequest"

  has_many :reminders_created,  foreign_key: "creator_id", class_name: "Reminder"
  has_many :reminders_reminded, foreign_key: "caller_id",  class_name: "Reminder"

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :reports_created,  foreign_key: "reporter_id", class_name: "Report"
  has_many :reports_assigned, foreign_key: "reportee_id", class_name: "Report"

  validates :name,      presence: true
  validates :active,    presence: true

  has_many :comments
  has_many :likes
  # validates :rating,    presence: true, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5 }

  # validates :name,         presence: true
  # validates :active,       presence: true
  validates :phone_number, presence: true, length: { minimum: 10 }

  scope :in_reminder_lobby, ->(user) { where(ready_to_remind: true).where.not(id: user.id).order(updated_at: :desc) }
  scope :search_users, -> (query) { where("name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%") }

  def accept_friend_request(friend_request)
    friend_request.update(status: 'accepted')
    friends << friend_request.sender 
  end

  def decline_friend_request(friend_request)
    friend_request.destroy
  end

  def unfriend(user)
    friend_requests_sent
      .where(receiver: user)
      .where(status: 'accepted')
      .update_all(status: 'unfriended')
    friend_requests_received
      .where(sender: user)
      .where(status: 'accepted')
      .update_all(status: 'unfriended')
    friends.delete(user)
    user.friends.delete(self)
  end

  def follow(friend)
    if !friends_with(friend)
      errors.add(:friend, "Not friends with that user")
      return false
    end
    friendships.where(friend: friend).update_all(following: true)
  end

  def unfollow(friend)
    if !friends_with(friend)
      errors.add(:friend, "Not friends with that user")
      return false
    end
    friendships.where(friend: friend).update_all(following: false)
  end

  def followed_friends
    User.find(friendships.where(following: true).pluck(:friend_id))
  end

  def friends_with(user)
    return friends.where(id: user.id).count > 0
  end

  def has_pending_friend_request(user)
    return friend_requests_sent.where(receiver: user)
            .where.not(status: 'accepted')
            .where.not(status: 'unfriended')
            .count > 0 ||
          friend_requests_received.where(sender: user)
            .where.not(status: 'accepted')
            .where.not(status: 'unfriended')
            .count > 0
  end

  def toggle_profile_activity
    update(activity_hidden: !activity_hidden)
  end

  def hide_profile_activity
    return false if activity_hidden
    update(activity_hidden: true)
  end

  def show_profile_activity
    return false unless activity_hidden
    update(activity_hidden: false)
  end

  def friend_activity
    (followed_friends.map{|friend| friend.activity} << self.activity).flatten.sort_by { |hsh| hsh[:time] }.reverse
  end

  def activity    
    # activity_hash = {}
    # activity_hash["reminders_created"] = reminders_created.to_a.select { |x| x.public }
    # activity_hash["reminders_reminded"] = reminders_reminded.to_a.select { |x| x.public }

    # activity_hash

    return if activity_hidden

    activity_array = []

    reminders_created.each do |reminder|
      return unless reminder.public

      activity_hash = {
        id: reminder.id,
        title: reminder.title,
        description: reminder.description,
        type: "reminder-created",
        user_id: id,
        user_name: name,
        time: reminder.created_at
      }

      activity_array << activity_hash
    end

    reminders_reminded.each do |reminder|
      return unless reminder.public

      activity_hash = {
        id: reminder.id,
        title: reminder.title,
        description: reminder.description,
        type: "reminder-reminded",
        user_id: id,
        user_name: name,
        time: reminder.created_at
      }

      activity_array << activity_hash
    end
    activity_array
  end

  def self.login_or_create_from_facebook(facebook_params)
    return unless valid_fb_authtoken?(facebook_params[:facebook_token], facebook_params[:email])

    user = User.find_by(facebook_token: facebook_params[:facebook_token])

    if user.blank?
      user = User.find_by_email(facebook_params[:email])

      if user.present?
        user.facebook_token = facebook_params[:facebook_token]
      else
        user = User.new(facebook_params)
        user.password = facebook_params[:facebook_token]
        user.facebook_token = facebook_params[:facebook_token]
      end
    end

    user
  end

  def self.login_or_create_from_google(google_params)
    return unless valid_google_authtoken?(google_params[:google_token], google_params[:email])

    user = User.find_by(google_token: google_params[:google_token])

    if user.blank?
      user = User.find_by_email(google_params[:email])

      if user.present?
        user.google_token = google_params[:google_token]
      else
        user = User.new(google_params)
        user.password = google_params[:google_token]
        user.google_token = google_params[:google_token]
      end
    end

    user
  end


  def join_reminder_lobby
    return false if ready_to_remind
    update(ready_to_remind: true)
  end

  def leave_reminder_lobby
    return false if !ready_to_remind
    update(ready_to_remind: false)
  end

  
  def self.valid_fb_authtoken?(fb_authtoken, email)
    response = HTTParty.get("https://graph.facebook.com/me?"\
      "access_token=#{fb_authtoken}&fields=email")
    response["email"].present? && response["email"] == email
  end

  
  def self.valid_google_authtoken?(google_authtoken, email)
    response = HTTParty.get("https://www.googleapis.com/oauth2/v3/tokeninfo?"\
      "id_token=#{google_authtoken}")
    response["email"].present? && response["email"] == email
  end
end
