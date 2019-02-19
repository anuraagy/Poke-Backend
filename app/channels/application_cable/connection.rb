module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      current_user = authenticated_user
      puts "Name: #{current_user.name}"
      current_user.join_reminder_lobby
    end

    private

    def authenticated_user
      if verified_token?
        current_user ||= User.find_by_email(auth_token[:email])
        
        if current_user.blank?
          reject_unauthorized_connection
        else
          return current_user
        end
      else
        reject_unauthorized_connection
      end
    end

    def http_token
      @http_token ||= if request.params[:authorization].present?
        request.params[:authorization].split(' ').last
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
