module Request
  module JSONHelper
    def json
      JSON.parse(response.body)
    end
  end

  module AuthenticationHelper
    def http_login(user)
      post '/api/v1/users/authenticate',
        params: {
          email: user.email,
          password: user.password
        }
      @token = json['auth_token']
    end

    def auth_headers
      { 'Authorization': "Bearer #{@token}" }
    end

    def auth_user
      @user
    end
  end

  module SocialHelper
    def send_friend_request(sender, receiver, headers)
      post "/api/v1/users/#{sender.id}/send_friend_request/",
        params: {
          friend_id: receiver.id,
        },
        headers: headers
    end
  end
end