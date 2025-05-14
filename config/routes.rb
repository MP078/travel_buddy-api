# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  mount_devise_token_auth_for "User", at: "auth",
  controllers: {
    registrations: "auth/registrations"
  }

  # User routes
  resources :users, param: :username, only: %i[index show update]

  # User posts routes
  resources :posts

  # Rails health check
  get "up" => "rails/health#show", as: :rails_health_check
end
