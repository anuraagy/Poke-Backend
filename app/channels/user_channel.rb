class UserChannel < ApplicationCable::Channel
  def subscribed
    current_user = authenticate_user
    current_user.join_reminder_lobby
    stream_for current_user
  end

  def unsubscribed
    current_user = authenticate_user
    current_user.leave_reminder_lobby if current_user.present?
  end

  def authenticate_user
    if verified_token?
      current_user ||= User.find_by_email(auth_token[:email])
      
      if current_user.blank?
        reject_subscription
      else
        return current_user
      end
    else
      reject_subscription
    end
  end

  def auth_token
    @auth_token ||= JSONWebToken.decode(params[:authToken])
  end

  def verified_token?
    auth_token && auth_token[:email].present?
  end
end