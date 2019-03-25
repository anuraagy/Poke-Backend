require 'rails_helper'

describe 'Reminders API' do
  include ActiveJob::TestHelper
  
  before :each do 
    user_params = {
      name: "Test",
      email: "test@test.com", 
      password: "password",
      device_token: "not_a_device_token",
      phone_number: "1234567890"
    }
    @user = User.create!(user_params)
    @reminder = Reminder.create!({
      title: "New",
      creator: @user,
      description: "test",
      will_trigger_at: Time.now + 10.minutes,

    })
  
    user2_params = {
      name: "Test2",
      email: "test2@test.com", 
      password: "password",
      phone_number: "1234567890"
    }
    @user2 = User.create!(user2_params)


    http_login(@user)
  end

  describe 'Reminder create' do
    describe "Invalid" do 
      it "no creator sent in body" do
        post '/api/v1/reminders',
          params: {
            title: "New",
            description: "Test description", 
            public: true,
            status: "nNw",
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Creator can't be blank")
      end

      it "no trigger time sent in body" do
        post '/api/v1/reminders',
          params: {
            title: "New",
            description: "Test description", 
            public: true,
            status: "New",
            creator_id: @user.id,
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end
    end
    
    describe "Valid" do 
      it "creates a reminder" do 
        post '/api/v1/reminders',
          params: {
            title: "New",
            description: "Test description",
            status: "New", 
            public: true,
            creator_id: @user.id,
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end    
  end

  describe 'Reminder update' do
    before :each do 
      reminder_params = {
        title: "New",
        description: "Test description",
        status: "New", 
        public: true,
        creator_id: @user.id,
        will_trigger_at: Time.now + 10.minutes
      }

      @reminder = Reminder.create!(reminder_params)
    end

    describe "Invalid" do 
      it "nil creator sent in body" do
        put "/api/v1/reminders/#{@reminder.id}",
          params: {
            title: "New",
            description: "Test description", 
            public: true,
            creator_id: nil,
            status: "nNw",
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Creator can't be blank")
      end

      it "nil trigger time sent in body" do
        put "/api/v1/reminders/#{@reminder.id}",
          params: {
            title: "New",
            description: "Test description", 
            public: true,
            status: "New",
            creator_id: @user.id,
            will_trigger_at: nil
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
      end
    end
    
    describe "Valid" do 
      it "creates a reminder" do 
        put "/api/v1/reminders/#{@reminder.id}",
          params: {
            title: "New",
            description: "New description",
            status: "New", 
            public: true,
            creator_id: @user.id,
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end

  describe 'Reminder destroy' do
    before :each do 
      reminder_params = {
        title: "New",
        description: "Test description",
        status: "New", 
        public: true,
        creator_id: @user.id,
        will_trigger_at: Time.now + 10.minutes
      }

      @reminder = Reminder.create!(reminder_params)
    end

    describe "Invalid" do 
      it "user didn't create reminder" do
        http_login(@user2)

        delete "/api/v1/reminders/#{@reminder.id}",
          headers: auth_headers
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    describe "Valid" do 
      it "deletes a reminder" do 
        delete "/api/v1/reminders/#{@reminder.id}",
          headers: auth_headers
        
        expect(response).to have_http_status(:ok)
      end
    end    
  end

  describe 'Reminder history' do
    describe 'Valid' do
      it 'get reminder history for user with no reminders' do
        http_login(@user2)
        get '/api/v1/reminders',
          headers: auth_headers
        resp = JSON.parse(response.body)
        expect(resp).to be_kind_of(Array)
        expect(resp).to be_empty
      end

      it 'get reminder history for user with reminders' do
        get '/api/v1/reminders',
          headers: auth_headers
        resp = JSON.parse(response.body)
        expect(resp).to be_kind_of(Array)
        expect(resp.size).to eq 1
        expect(resp.find { |i| i['id'] == @reminder.id }).to_not be_nil
      end
    end
  end
  describe 'Push notification reminders' do
    describe 'Valid' do
      it 'create push notification reminder' do
        http_login(@user)
        post '/api/v1/reminders',
          params: {
            title: "New",
            description: "Test description",
            status: "New", 
            public: true,
            push: true,
            creator_id: @user.id,
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['reminder']['push']).to be_truthy
      end
    end
    describe 'Invalid' do
      it 'create push notification reminder with no device_token' do
        http_login(@user2)
        post '/api/v1/reminders',
          params: {
            title: "New",
            description: "Test description",
            status: "New", 
            public: true,
            push: true,
            creator_id: @user2.id,
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  describe 'Reminder rating' do
    before :each do 
      reminder_params = {
        title: "New",
        description: "Test description",
        status: "New", 
        public: true,
        push: false,
        creator_id: @user.id,
        will_trigger_at: Time.now + 10.minutes
      }

      @reminder = Reminder.create!(reminder_params)
    end

    describe 'Valid' do
      it 'sets a rating for caller and creator' do
        @reminder.update(caller: @user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: [@reminder.id],
            ratings: [3]
          },
          headers: auth_headers
        expect(Reminder.find_by_id(@reminder.id).caller_rating).to eq 3
        expect(response).to have_http_status(:ok)
        http_login(@user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: [@reminder.id],
            ratings: [5]
          },
          headers: auth_headers
        expect(Reminder.find_by_id(@reminder.id).creator_rating).to eq 5
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'Invalid' do
      it 'ratings[] and id[] wrong type' do
        @reminder.update(caller: @user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: 3,
            ratings: 3
          },
          headers: auth_headers
        expect(response).to have_http_status(:bad_request)
      end
      it 'ratings[] and ids[] different sizes' do
        @reminder.update(caller: @user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: [3,5],
            ratings: [3]
          },
          headers: auth_headers
        expect(response).to have_http_status(:bad_request)
      end
      it 'ratings less than range' do
        @reminder.update(caller: @user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: [@reminder.id],
            ratings: [-1]
          },
          headers: auth_headers
        expect(response).to have_http_status(:bad_request)
      end
      it 'ratings less than range' do
        @reminder.update(caller: @user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: [@reminder.id],
            ratings: [-6]
          },
          headers: auth_headers
        expect(response).to have_http_status(:bad_request)
      end
      it 'user not part of reminder' do
        @reminder.update(caller: nil)
        http_login(@user2)
        post '/api/v1/reminders/rating',
          params: {
            ids: [@reminder.id],
            ratings: [3]
          },
          headers: auth_headers
        expect(Reminder.find_by_id(@reminder.id).creator_rating).to be_nil
        expect(Reminder.find_by_id(@reminder.id).caller_rating).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
