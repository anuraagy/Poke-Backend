require 'rails_helper'

describe 'Comments API API' do
  describe 'User creates comment' do
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
      @commentor = User.create!(user_params)

      http_login(@commentor)
    end

    describe "Invalid" do 
      it "no user sent in body" do
        post '/api/v1/comments/',
          params: {
            reminder_id: @reminder.id,
            content: "Comment 1"
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:unauthorized)
      end

      it "no reminder sent in body" do
        post '/api/v1/comments/',
          params: {
            user_id: @commentor.id,
            content: "Comment 1"
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end

      it "no content sent in body" do
        post '/api/v1/comments/',
          params: {
            reminder_id: @reminder.id,
            user_id: @commentor.id
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end
    end
    
    describe "Valid" do 
      it "creates a comment" do 
        post '/api/v1/comments',
          params: {
            reminder_id: @reminder.id,
            user_id: @commentor.id,
            content: "Comment 1"
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end

  describe 'User deletes comment' do
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
      @commentor = User.create!(user_params)

      @comment = Comment.create!({
        content: "Comment 1",
        user_id: @commentor.id,
        reminder_id: @reminder.id
      })

      http_login(@commentor)
    end

    describe "Invalid" do 
      it "no comment with that id is available" do        
        delete '/api/v1/comments/0',
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end

      it "user is not the same as the comment creator" do
        http_login(@poster)
        
        delete "/api/v1/comments/#{@comment.id}",
          headers: auth_headers
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    describe "Valid" do 
      it "deletes a comment" do 
        delete "/api/v1/comments/#{@comment.id}",
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end
end
