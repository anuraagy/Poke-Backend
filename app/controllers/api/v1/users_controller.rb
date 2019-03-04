class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_request!,
    only: [:index, :show, :update, :change_password, :profile_picture]

  def index
    # current user profile
    profile = {}
    #render status: :ok, json: current_user
    #return
    profile['user'] = UserSerializer.new(current_user)
    profile['reminder_count'] = Reminder.where(creator: current_user).count
    profile['active_reminders'] = Reminder.where(creator: current_user).where.not(status: 'triggered').count
    profile['times_reminded_others'] = Reminder.where(caller: current_user).count
    profile['next_reminder'] = Reminder.where(creator: current_user).where.not(status: 'triggered').order('will_trigger_at').first
    # user activity goes here next sprint
    render status: :ok, json: { profile: profile }
  end

  def show_id
        # other user's profile
        user = User.find(user_params[:id])
        if user.present?
          profile = {}
          profile['user'] = UserSerializer.new(user)
          profile['reminder_count'] = Reminder.where(creator: user).count
          profile['active_reminders'] = Reminder.where(creator: user).where.not(status: 'triggered').count
          profile['times_reminded_others'] = Reminder.where(caller: user).count
          # user activity goes here next sprint
          # limit activity based on friends, etc
          render status: :ok, json: { profile: profile }
        else
          render status: :bad_request, json: { errors: ["User not found"] }
        end
  end

  def show
    # other user's profile
    user = User.find_by(email: user_params[:email])
    if user.present?
      profile = {}
      profile['user'] = UserSerializer.new(user)
      profile['reminder_count'] = Reminder.where(creator: user).count
      profile['active_reminders'] = Reminder.where(creator: user).where.not(status: 'triggered').count
      profile['times_reminded_others'] = Reminder.where(caller: user).count
      # user activity goes here next sprint
      # limit activity based on friends, etc
      render status: :ok, json: { profile: profile }
    else
      render status: :bad_request, json: { errors: ["User not found"] }
    end

  end

  def authenticate
    user = User.find_by(email: user_params[:email])

    if user&.valid_password?(user_params[:password])
      render status: :ok, json: {
        auth_token: JSONWebToken.encode(user.as_json.symbolize_keys)
      }
    else
      render status: :unauthorized, json: { errors: ["Invalid email or password submitted"] }
    end
  end

  def register
    user = User.new(user_params)

    if user.save
      render status: :ok, json: {
        auth_token: JSONWebToken.encode(user.as_json.symbolize_keys)
      }
    else
      render status: :bad_request, json: { errors: user.errors.full_messages.as_json }
    end
  end

  def facebook
    user = User.login_or_create_from_facebook(facebook_params)

    if user.blank?
      render status: :unauthorized, json: { errors: ["This is an invalid facebook token!"] }
    else 
      user.save(validate: false)
      render status: :ok, json: {
        auth_token: JSONWebToken.encode(user.as_json.symbolize_keys)
      }
    end
  end

  def google
    user = User.login_or_create_from_google(google_params)

    if user.blank?
      render status: :unauthorized, json: { errors: ["This is an invalid google token!"] }
    else 
      user.save(validate: false)
      render status: :ok, json: {
        auth_token: JSONWebToken.encode(user.as_json.symbolize_keys)
      }
    end
  end

  def change_password
    user = User.find_by(id: params[:id])

    if user.blank?
      render status: :unauthorized, json: { errors: ["There is no user with that id"] }
    elsif user != current_user
      render status: :forbidden, json: { errors: ["You do not have access to this user"] }
    elsif !user.valid_password?(params[:old_password])
      render status: :forbidden, json: { errors: ["The old password you entered is incorrect."] }
    elsif user&.update(password: params[:new_password])
      render status: :ok, json: { success: true }
    else
      render status: 400, json: { errors: user.errors.full_messages }
    end
  end

  def update
    user = User.find_by(id: params[:id])

    if user != current_user
      render status: :forbidden, json: { errors: ["You do not have access to this user"] }
    elsif user&.update(user_params)
      render status: :ok, json: {
        auth_token: JSONWebToken.encode(user.as_json.symbolize_keys)
      }
    else
      render status: :unauthorized, json: { errors: user.errors.full_messages }
    end
  end

  def profile_picture
      # other user's profile
      user = User.find_by(email: user_params[:email])
      if user.present?
        render status: :ok, json: { profile_picture: user.profile_picture }
      else
        render status: :bad_request, json: { errors: ["User not found"] }
      end
  end

  private

  def facebook_params
    params.permit(
      :name,
      :twilio_id,
      :email,
      :facebook_token,
      :phone_number,
      :device_token
    )
  end

  def google_params
    params.permit(
      :name,
      :twilio_id,
      :email,
      :google_token,
      :phone_number,
      :device_token
    )
  end

  def user_params
    params.permit(
      :id,
      :twilio_id,
      :name,
      :email, 
      :password, 
      :bio, 
      :active, 
      :rating,
      :phone_number,
      :profile_picture,
      :device_token
    )
  end
end