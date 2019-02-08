Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        post 'register',      to: "register",      on: :collection
        post 'authenticate',  to: "authenticate",  on: :collection
        post 'confirm',       to: "confirm",       on: :collection
        
        post 'facebook',      to: "facebook",      on: :collection
        post 'google',        to: "google",        on: :collection

        get  '/:email',       action: 'show',      on: :collection, :constraints  => { :email => /[0-z\.]+/ }
      end

      resources :reminders, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
