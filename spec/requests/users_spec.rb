require 'rails_helper'

describe 'Users API' do

  describe 'User register' do
    describe "Invalid" do 
      it "no email sent in body" do
        post '/api/v1/users/register',
          params: {
            email: nil,
            password: "password"
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Email can't be blank")
      end

      it "no password sent in body" do
        post '/api/v1/users/register',
          params: {
            email: "test@tester.com",
            password: nil
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Password can't be blank")
      end

      it "email is already being used" do
        user_params = {
          email: "test@tester.com",
          name: "test",
          password: "password"
        }

        user = User.create!(user_params)

        post '/api/v1/users/register',
          params: user_params
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Email has already been taken")
      end

      it "email is not in proper format" do
        post '/api/v1/users/register',
          params: {
            email: "test",
            password: "password"
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Email is invalid")
      end

      it "password is less than six characters" do 
        post '/api/v1/users/register',
          params: {
            email: "test@tester.com",
            password: "1"
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Password is too short (minimum is 6 characters)")
      end
    end
    
    describe "Valid" do 
      it "registers a user" do 
        post '/api/v1/users/register',
          params: {
            email: "valid@tester.com",
            name: "nonblank name",
            password: "password"
          }
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end

  describe 'User authenticate with email/password' do
    before :each do
      user_params = {
        name: "Tester",
        email: "tester@test.com", 
        password: "password"
      }
      @user = User.create!(user_params)
    end

    describe "Invalid" do 
      it "no email sent in body" do
        post '/api/v1/users/authenticate',
          params: {
            email: nil,
            password: "password"
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end

      it "no password sent in body" do
        post '/api/v1/users/authenticate',
          params: {
            email: "tester@test.com",
            password: nil
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end

      it "invalid password is submitted" do
        post '/api/v1/users/authenticate',
          params: {
            email: "tester@test.com",
            password: "blehbleh"
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end

      it "email is not in proper format" do
        post '/api/v1/users/authenticate',
          params: {
            email: "tester",
            password: "password"
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end
    end

    describe "Valid" do
      it "authenticates a valid user" do 
        post '/api/v1/users/authenticate',
          params: {
            email: "tester@test.com",
            password: "password"
          }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'User authenticate with facebook' do
    describe "Invalid" do 
      it "no email sent in body" do
        post '/api/v1/users/facebook',
          params: {
            email: nil,
            facebook_token: "oqwaisfasdkjfyawaeoriyuw"
          }
        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("This is an invalid facebook token!")
      end

      it "no facebook token sent in body" do
        post '/api/v1/users/facebook',
          params: {
            email: "test@tset.com",
            facebook_token: nil
          }
        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("This is an invalid facebook token!")
      end

      it "email is not in proper format" do
        post '/api/v1/users/facebook',
          params: {
            email: "etst",
            facebook_token: "oqwaisfasdkjfyawaeoriyuw"
          }
        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("This is an invalid facebook token!")
      end
    end
  end
  
  describe 'Current user profile' do
    describe 'Valid' do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password"
        }
        @user = User.create!(user_params)
        @reminder = Reminder.create!({
          title: "New",
          creator: @user,
          description: "test",
          will_trigger_at: Time.now + 10.minutes,
    
        })
        reminder1 = Reminder.create!({
          title: "New",
          creator: @user,
          description: "test1",
          will_trigger_at: Time.now + 15.minutes,
    
        })
        reminder2 = Reminder.create!({
          title: "New",
          creator: @user,
          description: "test2",
          will_trigger_at: Time.now + 6.minutes,
          status: 'triggered'
    
        })
        http_login(@user)
      end

      it 'current user can get their own profile' do
        get '/api/v1/users',
          headers: auth_headers
          resp = JSON.parse(response.body)['profile']
          expect(resp['user']['id']).to eq @user.id
          expect(resp['reminder_count']).to eq 3
          expect(resp['active_reminders']).to eq 2
          expect(resp['times_reminded_others']).to eq 0
          expect(resp['next_reminder']['id']).to eq @reminder.id
          expect(response).to have_http_status :ok
      end
    end
    describe 'Invalid' do
      it 'user not authenticated' do
        get '/api/v1/users'
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "User update" do
    describe "Invalid" do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password"
        }
        @user = User.create!(user_params)

        http_login(@user)
      end

      it "bad id is sent in request" do
        put '/api/v1/users/-1',
          params: {
            name: "Blank"
          },
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password"
        }
        @user = User.create!(user_params)

        http_login(@user)
      end

      it "change name to blank" do
        put "/api/v1/users/#{@user.id}",
          params: {
            name: "Blank"
          },
          headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "User report" do
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @reporter = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @reportee = User.create!(user_params)

      http_login(@reporter)
    end

    describe "Invalid" do 
      it "no reporter sent" do
        post "/api/v1/users/report",
          params: {
            reportee_id: @reportee.id,
            reason: "They were bad"
          },
          headers: auth_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "no reportee sent" do
        post "/api/v1/users/report",
          params: {
            reporter_id: @reporter.id,
            reason: "They were bad"
          },
          headers: auth_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "no reason sent" do
        post "/api/v1/users/report",
          params: {
            reporter_id: @reporter.id,
            reportee_id: @reportee.id,
          },
          headers: auth_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "reporter isn't current user" do
        post "/api/v1/users/report",
          params: {
            reporter_id: @reportee.id,
            reportee_id: @reporter.id,
            reason: "They were bad"
          },
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      it "creates a valid report" do
        post "/api/v1/users/report",
          params: {
            reporter_id: @reporter.id,
            reportee_id: @reportee.id,
            reason: "They were bad"
          },
          headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "User sends a friend request" do
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @receiver = User.create!(user_params)

      http_login(@sender)
    end

    describe "Invalid" do
      it "no friend in body" do
        post "/api/v1/users/#{@sender.id}/send_friend_request/",
          params: {
          },
          headers: auth_headers

        expect(response).to have_http_status(:bad_request)
      end

      it "sender is different than current user" do
        post "/api/v1/users/#{@receiver.id}/send_friend_request/",
          params: {
            friend_id: @sender.id,
            reason: "They were bad"
          },
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      it "sends a friend request" do
        post "/api/v1/users/#{@sender.id}/send_friend_request/",
          params: {
            friend_id: @receiver.id,
          },
          headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(@sender.friend_requests_sent).not_to be_empty
      end
    end
  end

  describe "User accepts a friend request" do 
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @receiver = User.create!(user_params)

      http_login(@sender)
      send_friend_request(@sender, @receiver, auth_headers)
      http_login(@receiver)
    end

    describe "Invalid" do
      it "no friend in body" do
        post "/api/v1/users/#{@receiver.id}/accept_friend_request/",
          params: {
          },
          headers: auth_headers

        expect(response).to have_http_status(:bad_request)
      end

      it "receiver is different than current user" do
        post "/api/v1/users/#{@sender.id}/accept_friend_request/",
          params: {
            friend_request: @sender.friend_requests_sent.last.id,
          },
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      it "accepts a friend request" do
        post "/api/v1/users/#{@receiver.id}/accept_friend_request/",
          params: {
            friend_request: @sender.friend_requests_sent.last.id,
          },
          headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(@sender.friends).to include(@receiver)
        expect(@receiver.friends).to include(@sender)
      end
    end
  end

  describe "User declines a friend request" do 
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password"
      }
      @receiver = User.create!(user_params)

      http_login(@sender)
      send_friend_request(@sender, @receiver, auth_headers)
      http_login(@receiver)
    end

    describe "Invalid" do
      it "no friend in body" do
        post "/api/v1/users/#{@receiver.id}/decline_friend_request/",
          params: {
          },
          headers: auth_headers

        expect(response).to have_http_status(:bad_request)
      end

      it "receiver is different than current user" do
        post "/api/v1/users/#{@sender.id}/decline_friend_request/",
          params: {
            friend_request: @sender.friend_requests_sent.last.id,
          },
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      it "accepts a friend request" do
        post "/api/v1/users/#{@receiver.id}/decline_friend_request/",
          params: {
            friend_request: @sender.friend_requests_sent.last.id,
          },
          headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(@sender.friends).not_to include(@receiver)
        expect(@receiver.friends).not_to include(@sender)
      end
    end
  end

  describe "User view friend requests" do 

  end

  describe "User seaches for friends" do 

  end

  describe "User views friend activity" do 

  end

  describe "User hides profile activity" do

  end



  describe 'Other user profile' do
    describe 'Valid' do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test1.com", 
          password: "password"
        }
        @user1 = User.create!(user_params)
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password"
        }
        @user = User.create!(user_params)
        @reminder = Reminder.create!({
          title: "New",
          creator: @user,
          description: "test",
          will_trigger_at: Time.now + 10.minutes,
    
        })
        reminder1 = Reminder.create!({
          title: "New",
          creator: @user,
          description: "test1",
          will_trigger_at: Time.now + 15.minutes,
    
        })
        reminder2 = Reminder.create!({
          title: "New",
          creator: @user,
          description: "test2",
          will_trigger_at: Time.now + 6.minutes,
          status: 'triggered'
    
        })
        http_login(@user1)
      end

      it 'current user can get others profile' do
        get "/api/v1/users/#{@user.email}",
          headers: auth_headers
          resp = JSON.parse(response.body)['profile']
          expect(resp['user']['id']).to eq @user.id
          expect(resp['reminder_count']).to eq 3
          expect(resp['active_reminders']).to eq 2
          expect(resp['times_reminded_others']).to eq 0
          expect(resp['next_reminder']).to be_nil
          expect(response).to have_http_status :ok
      end
    end
    describe 'Invalid' do
      it 'user not authenticated' do
        get '/api/v1/users'
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
