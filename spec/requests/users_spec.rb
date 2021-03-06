require 'rails_helper'

describe 'Users API' do

  describe 'User register' do
    describe "Invalid" do 
      it "no email sent in body" do
        post '/api/v1/users/register',
          params: {
            email: nil,
            password: "password",
            phone_number: "1234567890"
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Email can't be blank")
      end

      it "no password sent in body" do
        post '/api/v1/users/register',
          params: {
            email: "test@tester.com",
            password: nil,
            phone_number: "1234567890"
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Password can't be blank")
      end

      it "email is already being used" do
        user_params = {
          email: "test@tester.com",
          name: "test",
          password: "password",
          phone_number: "1234567890"
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
            password: "password",
            phone_number: "1234567890"
          }
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Email is invalid")
      end

      it "password is less than six characters" do 
        post '/api/v1/users/register',
          params: {
            email: "test@tester.com",
            password: "1",
            phone_number: "1234567890"
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
            password: "password",
            phone_number: "1234567890"
          }
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end
  describe "Update user" do
    describe "Valid" do 
      it "updates a user" do 
          user_params = {
            email: "valid@tester.com",
            name: "nonblank name",
            password: "password",
            phone_number: "1234567890"
          }
          user = User.create!(user_params)
          http_login(user)
          put "/api/v1/users/#{user.id}",
          params: {
            name: "new name",
            password: "new pass",
            phone_number: "0987654321",
            device_token: "token"
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end
    describe "Invalid" do 
      it "updates a user, unauthenticated" do 
          user_params = {
            email: "valid@tester.com",
            name: "nonblank name",
            password: "password",
            phone_number: "1234567890"
          }
          user = User.create!(user_params)
          put "/api/v1/users/#{user.id}",
          params: {
            name: "new name",
            password: "new pass",
            phone_number: "0987654321",
            device_token: "token"
          }
        
        expect(response).to have_http_status(:unauthorized)
      end
      it "users invalid fields" do 
        user_params = {
          email: "valid@tester.com",
          name: "nonblank name",
          password: "password",
          phone_number: "1234567890"
        }
        user = User.create!(user_params)
        put "/api/v1/users/#{user.id}",
        params: {
          email: "invalid",
          password: "bad",
          phone_number: "not_a_phone_number",
        }
      
      expect(response).to have_http_status(:unauthorized)
    end
    end
  end

  describe 'User authenticate with email/password' do
    before :each do
      user_params = {
        name: "Tester",
        email: "tester@test.com", 
        password: "password",
        phone_number: "1234567890"
      }
      @user = User.create!(user_params)
    end

    describe "Invalid" do 
      it "no email sent in body" do
        post '/api/v1/users/authenticate',
          params: {
            email: nil,
            password: "password",
            phone_number: "1234567890"
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end

      it "no password sent in body" do
        post '/api/v1/users/authenticate',
          params: {
            email: "tester@test.com",
            password: nil,
            phone_number: "1234567890"
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end

      it "invalid password is submitted" do
        post '/api/v1/users/authenticate',
          params: {
            email: "tester@test.com",
            password: "blehbleh",
            phone_number: "1234567890"
          }

        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("Invalid email or password submitted")
      end

      it "email is not in proper format" do
        post '/api/v1/users/authenticate',
          params: {
            email: "tester",
            password: "password",
            phone_number: "1234567890"
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
            password: "password",
            phone_number: "1234567890"
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
            facebook_token: "oqwaisfasdkjfyawaeoriyuw",
            phone_number: "1234567890"
          }
        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("This is an invalid facebook token!")
      end

      it "no facebook token sent in body" do
        post '/api/v1/users/facebook',
          params: {
            email: "test@tset.com",
            facebook_token: nil,
            phone_number: "1234567890"
          }
        expect(response).to have_http_status(:unauthorized)
        expect(json["errors"]).to include("This is an invalid facebook token!")
      end

      it "email is not in proper format" do
        post '/api/v1/users/facebook',
          params: {
            email: "etst",
            facebook_token: "oqwaisfasdkjfyawaeoriyuw",
            phone_number: "1234567890"
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
          password: "password",
          phone_number: "1234567890"
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
          password: "password",
          phone_number: "1234567890"
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
          password: "password",
          phone_number: "1234567890"
        }
        @user = User.create!(user_params)

        http_login(@user)
      end

      it "change name to blank" do
        put "/api/v1/users/#{@user.id}",
          params: {
            name: "Blank",
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
        password: "password",
        phone_number: "1234567890"
      }
      @reporter = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
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
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
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
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
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
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
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

  describe "User views friend requests" do 
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @receiver = User.create!(user_params)

      http_login(@sender)
      send_friend_request(@sender, @receiver, auth_headers)
      http_login(@receiver)
    end

    describe "Invalid" do
      it "user id is bad" do
        get "/api/v1/users/-1/friend_requests_received/",
          params: {
          },
          headers: auth_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "user is different than current user" do
        get "/api/v1/users/#{@sender.id}/friend_requests_received/",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      it "views friend requests" do
        get "/api/v1/users/#{@receiver.id}/friend_requests_received/",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end

  end

  describe "User seaches for other users" do 
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @user2 = User.create!(user_params)

      user_params = {
        name: "Test1",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }

      @user3 = User.create!(user_params)

      user_params = {
        name: "Test2",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @user4 = User.create!(user_params)

      http_login(@sender)
    end

    describe "Invalid" do
      it "no query sent" do
        get "/api/v1/users/search",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "Valid" do
      it "search for users with the name Test" do
        get "/api/v1/users/search",
          params: {
            query: "Test"
          },
          headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end

  end

  describe "User views friend activity" do
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @user2 = User.create!(user_params)

      @sender.friends << @user2
      @user2.reminders_created.create(
        title: "Test",
        description: "Test",
        will_trigger_at: Time.now + 10.days
      )

      http_login(@sender)
    end

    describe "Invalid" do
      it "user id is bad" do
        get "/api/v1/users/-1/friend_activity/",
          params: {
          },
          headers: auth_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "user is different than current user" do
        get "/api/v1/users/#{@user2.id}/friend_activity/",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      it "views friend requests" do
        get "/api/v1/users/#{@sender.id}/friend_activity/",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "private doesnt appear in activity" do
    before :each do 
      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @sender = User.create!(user_params)

      user_params = {
        name: "Test",
        email: Faker::Internet.email, 
        password: "password",
        phone_number: "1234567890"
      }
      @user2 = User.create!(user_params)

      @sender.friends << @user2
      
      reminder_params = {
        title: "New",
        description: "Test description",
        status: "New", 
        public: false,
        push: false,
        creator_id: @user2.id,
        will_trigger_at: Time.now + 10.minutes
      }
      @reminder = Reminder.create!(reminder_params)

      http_login(@sender)
    end

    describe "Valid" do
      it "tests if a private reminder shows up in activity" do
        get "/api/v1/users/#{@sender.id}/friend_activity/",
          params: {},
          headers: auth_headers
        expect(response).to have_http_status(:ok)
        resp = JSON.parse(response.body)
        expect(resp['friend_activity'][0][@user2.name]['reminders_created']).to be_empty
        expect(resp['friend_activity'][0][@user2.name]['reminders_reminded']).to be_empty
      end
    end
  end

  describe "User hides profile activity" do
    describe "Invalid" do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password",
        phone_number: "1234567890"
        }
        @user = User.create!(user_params)

        user_params = {
          name: "Test",
          email: "test@test2.com", 
          password: "password",
        phone_number: "1234567890"
        }

        @user2 = User.create!(user_params)


        http_login(@user)
      end

      it "bad id is sent in request" do
        post '/api/v1/users/-1/hide_profile_activity/',
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "bad id is sent in request" do
        post "/api/v1/users/#{@user2.id}/hide_profile_activity/",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "Valid" do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password",
          phone_number: "1234567890"
        }
        @user = User.create!(user_params)

        http_login(@user)
      end

      it "hide profile activity" do
        post "/api/v1/users/#{@user.id}/hide_profile_activity/",
          params: {},
          headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(User.find(@user.id).activity_hidden).to eq(true)
      end
    end
  end


  describe 'Other user profile' do
    describe 'Valid' do
      before :each do 
        user_params = {
          name: "Test",
          email: "test@test1.com", 
          password: "password",
          phone_number: "1234567890"
        }
        @user1 = User.create!(user_params)
        user_params = {
          name: "Test",
          email: "test@test.com", 
          password: "password",
          phone_number: "1234567890"
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
