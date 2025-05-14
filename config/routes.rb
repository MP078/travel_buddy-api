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
  resources :posts do
    resources :comments, only: [:index, :create], module: :posts
    member do
      post "like"
      delete "unlike"
    end
  end

  resources :comments, only: %i[like unlike] do
    member do
      post "like"
      delete "unlike"
    end
    resources :replies, only: [:create], controller: "comments/replies"
  end

  # Rails health check
  get "up" => "rails/health#show", as: :rails_health_check
end
