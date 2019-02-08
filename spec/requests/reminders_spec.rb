require 'rails_helper'

describe 'Reminders API' do
  before :each do 
    user_params = {
      name: "Test",
      email: "test@test.com", 
      password: "password"
    }
    @user = User.create!(user_params)
    @reminder = Reminder.create!({
      creator: @user,
      description: "test",
      will_trigger_at: Time.now + 10.minutes,

    })
  
    user2_params = {
      name: "Test2",
      email: "test2@test.com", 
      password: "password"
    }
    @user2 = User.create!(user2_params)


    http_login(@user)
  end

  describe 'Reminder create' do
    describe "Invalid" do 
      it "no description sent in body" do
        post '/api/v1/reminders',
          params: {
            status: "New", 
            public: true,
            creator_id: @user.id,
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Description can't be blank")
      end

      it "no creator sent in body" do
        post '/api/v1/reminders',
          params: {
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
        description: "Test description",
        status: "New", 
        public: true,
        creator_id: @user.id,
        will_trigger_at: Time.now + 10.minutes
      }

      @reminder = Reminder.create!(reminder_params)
    end

    describe "Invalid" do 
      it "nil description sent in body" do
        put "/api/v1/reminders/#{@reminder.id}",
          params: {
            description: nil,
            status: "New", 
            public: true,
            creator_id: @user.id,
            will_trigger_at: Time.now + 10.minutes
          },
          headers: auth_headers
        
        expect(response).to have_http_status(:bad_request)
        expect(json["errors"]).to include("Description can't be blank")
      end

      it "nil creator sent in body" do
        put "/api/v1/reminders/#{@reminder.id}",
          params: {
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
      it "creates a reminder" do 
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

end
