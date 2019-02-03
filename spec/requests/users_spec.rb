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
end
