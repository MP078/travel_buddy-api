# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth",
  controllers: {
    registrations: "auth/registrations"
  }

  # User routes
  get "/users/photos", to: "users#photos", as: :user_photos
  get "/users", to: "users#index", as: :users
  get "/users/:username", to: "users#show", as: :user


  patch "/users", to: "users#update", as: :update_current_user

  resources :friendships, only: [:index, :destroy], param: :username do
    member do
      post :accept
      post :reject
    end
    collection do
      get :received_requests
      get :sent_requests
    end
  end

  post "/friendships/:username", to: "friendships#create", as: :send_friend_request


  # User posts routes
  resources :posts do
    resources :comments, only: [:index, :create], module: :posts
    member do
      post "like"
      delete "unlike"
    end
  end

  resources :comments do
    member do
      post :like
      delete :unlike
    end
  end

  resources :destinations do
  member do
    post :upload_pdf
    get :view_pdf
    get :download_pdf
  end
end


  # User ratings routes
  resources :ratings, only: [:index, :create, :update]

  resources :trips do
  resources :trip_participations, only: [:create, :destroy] do
    member do
      post :promote
      post :approve
    end
  end

  delete "leave", to: "trip_participations#leave", as: :leave_trip_participation
end

  resources :trip_participations, only: [] do
    collection do
      get :pending
    end
  end

  get "/list_pending_participants", to: "trips#list_pending_participants", as: :list_pending_participants


  resources :stories, param: :username

  resources :chat_messages, only: [:index, :create]

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end


  # Rails health check
  get "up" => "rails/health#show", as: :rails_health_check

  # for action cable
  mount ActionCable.server => "/cable"
end
