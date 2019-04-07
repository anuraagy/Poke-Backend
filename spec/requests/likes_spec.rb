require 'rails_helper'

describe 'Likes API API' do
  describe 'User creates like' do
    before :each do
      user_params = {
        name: "Tester",
        email: "tester@test.com", 
        password: "password",
        phone_number: "1234567890"
      }
      @poster = User.create!(user_params)
      
      @reminder = Reminder.create!({
        title: "New",
        creator: @poster,
        description: "test",
        will_trigger_at: Time.now + 10.minutes,
      })

      user_params = {
        name: "Tester",
        email: "tester2@test.com", 
        password: "password",
        phone_number: "1234567890"
      }
      @liker = User.create!(user_params)

      http_login(@liker)
    end

    describe "Invalid" do 
      it "no user sent in body" do
        post '/api/v1/likes/',
          params: {
            reminder_id: @reminder.id
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:unauthorized)
      end

      it "no reminder sent in body" do
        post '/api/v1/likes/',
          params: {
            user_id: @liker.id
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end
    end
    
    describe "Valid" do 
      it "creates a like" do 
        post '/api/v1/likes',
          params: {
            reminder_id: @reminder.id,
            user_id: @liker.id
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end

  describe 'User deletes like' do
    before :each do
      user_params = {
        name: "Tester",
        email: "tester@test.com", 
        password: "password",
        phone_number: "1234567890"
      }
      @poster = User.create!(user_params)
      
      @reminder = Reminder.create!({
        title: "New",
        creator: @poster,
        description: "test",
        will_trigger_at: Time.now + 10.minutes,
      })

      user_params = {
        name: "Tester",
        email: "tester2@test.com", 
        password: "password",
        phone_number: "1234567890"
      }
      @liker = User.create!(user_params)

      @like = Like.create!({
        user_id: @liker.id,
        reminder_id: @reminder.id
      })

      http_login(@liker)
    end

    describe "Invalid" do 
      it "no like with that id is available" do        
        delete '/api/v1/likes/0',
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end

      it "user is not the same as the like creator" do
        http_login(@poster)
        
        delete "/api/v1/likes/#{@like.id}",
          headers: auth_headers
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    describe "Valid" do 
      it "deletes a like" do 
        delete "/api/v1/likes/#{@like.id}",
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end
end
