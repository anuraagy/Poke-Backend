Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :twilio do
        get  'access_token',  to: 'access_token', on: :collection
        post "make_call",  to: 'make_call',  on: :collection
        post "place_call", to: 'place_call', on: :collection
      end
      resources :users, only: [:index, :update] do
        post 'register',        to: "register",        on: :collection
        post 'authenticate',    to: "authenticate",    on: :collection
        post 'confirm',         to: "confirm",         on: :collection
        post 'change_password', to: 'change_password', on: :member
        
        post 'facebook',      to: "facebook",      on: :collection
        post 'google',        to: "google",        on: :collection

        post 'report', to: "report", on: :collection

        get  'search', to: "search", on: :collection

        get  "friends",                   to: "friends",                   on: :member
        get  "friend_requests_sent",      to: "friend_requests_sent",      on: :member
        get  "friend_requests_received",  to: "friend_requests_received",  on: :member

        post "send_friend_request",       to: "send_friend_request",       on: :member
        post "accept_friend_request",     to: "accept_friend_request",     on: :member
        post "decline_friend_request",    to: "decline_friend_request",    on: :member

        get  '/:email',       action: 'show', on: :collection, :constraints  => { :email => /[0-z\.]+/ }
        get  '/profile_by_id/:id', action: 'show_id',   on: :collection
        get  '/:email/profile_picture', action: 'profile_picture',
          on: :collection, :constraints  => { :email => /[0-z\.]+/ }
      end

      resources :reminders, only: [:index, :show, :create, :update, :destroy] do
        post 'start', to: "start", on: :collection
        post 'end',   to: "end",   on: :collection
      end
    end
  end
end
