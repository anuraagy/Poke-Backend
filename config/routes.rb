Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        post 'register',      to: "register",      on: :collection
        post 'authenticate',  to: "authenticate",  on: :collection
        post 'confirm',       to: "confirm",       on: :collection
        
        post 'facebook',      to: "facebook",      on: :collection
        post 'google',        to: "google",        on: :collection
      end

      resources :reminders, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
