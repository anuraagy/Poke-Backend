Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :twilio do
        get  'access_token',  to: 'access_token', on: :collection
        post "make_call",  to: 'make_call',  on: :collection
        post "place_call", to: 'place_call', on: :collection
        post 'callback', to: 'callback', on: :collection
      end
      resources :users, only: [:index, :update] do
        post 'register',        to: "register",        on: :collection
        post 'authenticate',    to: "authenticate",    on: :collection
        post 'confirm',         to: "confirm",         on: :collection
        post 'change_password', to: 'change_password', on: :member
        
        post 'facebook',      to: "facebook",      on: :collection
        post 'google',        to: "google",        on: :collection

        get  '/:email',       action: 'show', on: :collection, :constraints  => { :email => /[0-z\.]+/ }
        get  '/profile_by_id/:id', action: 'show_id',   on: :collection
        get  '/:email/profile_picture', action: 'profile_picture',
          on: :collection, :constraints  => { :email => /[0-z\.]+/ }
      end

      resources :reminders, only: [:index, :show, :create, :update, :destroy] do
        post 'start',    to: "start",    on: :collection
        post 'end',      to: "end",      on: :collection
        post 'rating',   to: 'rating',   on: :member
        post 'complete', to: 'complete', on: :member
        get  'unrated',  to: 'unrated',  on: :collection
      end
    end
  end
end
