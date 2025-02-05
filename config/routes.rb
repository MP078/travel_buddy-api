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

    namespace :socialv1 do
      resources :friend_requests, only: [ :create, :index, :destroy ]
      resources :requests,        only: [ :index ]
      resources :friends,         only: [ :index ]
      resource  :friend,          only: [ :show, :destroy ]  # singular resource for viewing a friend’s profile or unfriending.
      post "request_reply", to: "request_reply#create"
        # optional endpoints
        resources :friend_suggestions, only: [ :index ]
        resources :mutual_friends,     only: [ :index ]
        resources :friend_search,      only: [ :index ]  # Optional
       # New posts, likes, and comments endpoints:
       resources :posts, only: [ :index, :show, :create, :update, :destroy ]
       post   "likes",    to: "likes#create"
       delete "likes",    to: "likes#destroy"
       post   "comments", to: "comments#create"
       delete "comments", to: "comments#destroy"
       #  user profile endpoint
       resource :my_profile,      only: [ :show, :update ], controller: "user_profile"
    end
  end
end
