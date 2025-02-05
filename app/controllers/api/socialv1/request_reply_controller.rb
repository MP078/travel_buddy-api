module Api
  module Socialv1
    class RequestReplyController < ApplicationController
      before_action :authenticate_user!
      before_action :find_target_user

      # POST /api/socialv1/request_reply
      # Body example:
      # {
      #   "target": {
      #     "email": "test@mail.com",
      #     "reply": "accept"
      #   }
      # }
      def create
        friend_request = FriendRequest.find_by(requester: @target, receiver: current_user)
        unless friend_request
          return render json: { message: "no such request exists" }, status: :not_found
        end

        reply = params[:target][:reply]
        case reply
        when "accept"
          # Create a friendship and remove the friend request.
          Friendship.create_friendship(current_user, @target)
          friend_request.destroy
          render json: { message: "friend request accepted" }
        when "reject"
          friend_request.destroy
          render json: { message: "friend request rejected" }
        else
          render json: { message: "invalid reply" }, status: :unprocessable_entity
        end
      end

      private

      def find_target_user
        target_params = params.require(:target).permit(:email, :user_name, :username, :reply)
        if target_params[:email]
          @target = User.find_by(email: target_params[:email])
        else
          @target = User.find_by(user_name: target_params[:user_name] || target_params[:username])
        end
        render json: { error: "Target user not found" }, status: :not_found unless @target
      end
    end
  end
end
