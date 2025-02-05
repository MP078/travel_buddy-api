module Api
  module Socialv1
    class RequestsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/socialv1/requests
      # Returns all friend requests received by the current user.
      def index
        received_requests = FriendRequest.where(receiver: current_user)
        render json: received_requests.map { |req|
          {
            requester: {
              name: req.requester.name,
              email: req.requester.email,
              user_name: req.requester.user_name
            }
          }
        }
      end
    end
  end
end
