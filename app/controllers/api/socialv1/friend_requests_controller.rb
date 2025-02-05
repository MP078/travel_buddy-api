module Api
  module Socialv1
    class FriendRequestsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_target_user, only: [ :create, :destroy ]

      # POST /api/socialv1/friend_requests
      # Body example:
      # {
      #   "target": { "email": "test@mail.com" }
      # }
      def create
        # Check if already friends
        if current_user.friends.exists?(@target.id)
          return render json: { message: "already friends" }, status: :unprocessable_entity
        end
        if current_user.id == @target.id
          return render json: { message: "cant send a request to yourself" }, status: :unprocessable_entity
        end

        # Check if a request has already been sent
        if FriendRequest.exists?(requester: current_user, receiver: @target)
          return render json: { message: "friend request already sent" }, status: :unprocessable_entity
        end

        friend_request = FriendRequest.new(requester: current_user, receiver: @target)
        if friend_request.save
          render json: { message: "friend request sent" }, status: :created
        else
          render json: { errors: friend_request.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/socialv1/friend_requests
      # Body example:
      # { "target": { "user_name": "test.user" } }
      def destroy
        friend_request = FriendRequest.find_by(requester: current_user, receiver: @target)
        if friend_request
          friend_request.destroy
          render json: { message: "friend request canceled" }
        else
          render json: { message: "no active request" }, status: :not_found
        end
      end

      # GET /api/socialv1/friend_requests
      # With no body: returns list of sent (pending) requests.
      # With a body target parameter: returns status of that particular request.
      def index
        if params[:target].present?
          # Check status of a specific request
          target = find_target_user_from_params
          friend_request = FriendRequest.find_by(requester: current_user, receiver: target)
            if friend_request
              render json: {
                target: {
                  name: target.name,
                  email: target.email,
                  user_name: target.user_name,
                  status: "pending"
                }
              }
            else
              # If already friends, reply “already friends”
              if current_user.friends.exists?(target.id)
                render json: { message: "already friends" }
              else
                render json: { message: "no active request" }
              end
            end
        else
          # List all sent (pending) friend requests
          sent_requests = FriendRequest.where(requester: current_user)
          render json: sent_requests.map { |req|
            {
              target: {
                name: req.receiver.name,
                email: req.receiver.email,
                user_name: req.receiver.user_name,
                status: "pending"
              }
            }
          }
        end
      end

      private

      # Finds target user from params and assigns to @target.
      def find_target_user
        @target = find_target_user_from_params
        render json: { error: "Target user not found" }, status: :not_found unless @target
      end

      # A helper that reads the target parameters. Accepts email, user_name, or username.
      def find_target_user_from_params
        target_params = params.require(:target).permit(:email, :user_name, :username)
        if target_params[:email]
          User.find_by(email: target_params[:email])
        else
          User.find_by(user_name: target_params[:user_name] || target_params[:username])
        end
      end
    end
  end
end
