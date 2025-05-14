# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth",
  controllers: {
    registrations: "auth/registrations"
  }

  # User routes
  resources :users, only: %i[index show update]

  # Rails health check
  get "up" => "rails/health#show", as: :rails_health_check
end
