module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      current_user = authenticated_user
      current_user.join_reminder_lobby
    end

    private

    def authenticated_user
      if verified_token?
        @current_user ||= User.find_by_email(auth_token[:email])
        reject_unauthorized_connection if @current_user.blank?
      else
        reject_unauthorized_connection
      end
    end

    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def auth_token
      @auth_token ||= JSONWebToken.decode(http_token)
    end

    def verified_token?
      http_token && auth_token && auth_token[:email].present?
    end
  end
end
