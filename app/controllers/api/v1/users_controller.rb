class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_request!, only: [:index, :show]

  def index
    # current user profile
    profile = {}
    profile['user'] = current_user
    profile['reminder_count'] = Reminder.where(creator: current_user).count
    profile['active_reminders'] = Reminder.where(creator: current_user).where.not(status: 'triggered').count
    profile['times_reminded_others'] = Reminder.where(caller: current_user).count
    profile['next_reminder'] = Reminder.where(creator: current_user).where.not(status: 'triggered').order('will_trigger_at').first
    # user activity goes here next sprint
    render status: :ok, json: { profile: profile }
  end

  def show
    # other user's profile
    user = User.find_by(email: user_params[:email])
    puts user.email
    puts request.url
    puts Reminder.where(creator: user).count
    if user.present?
      profile = {}
      profile['user'] = user
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

  private

  def facebook_params
    params.permit(
      :name,
      :email,
      :facebook_token
    )
  end

  def google_params
    params.permit(
      :name,
      :email,
      :google_token
    )
  end

  def user_params
    params.permit(
      :name,
      :email, 
      :password, 
      :bio, 
      :active, 
      :rating
    )
  end
end