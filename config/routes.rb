Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations" }

  namespace :api do
    namespace :v1 do
        resources :trips, only: [ :index, :create, :show, :destroy, :update ] do
            # for showing all trips
            collection do
              get "all_trips", to: "trips#all_trips"
            end
            # Adding join and unjoin routes
            member do
              post "join", to: "trips#join_trip"
              delete "leave", to: "trips#unjoin_trip"
            end
          end
    end
  end
end
