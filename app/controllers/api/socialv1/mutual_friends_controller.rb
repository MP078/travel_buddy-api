module Api
  module Socialv1
    class MutualFriendsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_target_user

      # GET /api/socialv1/mutual_friends
      # Request Body example:
      # {
      #   "target": { "email": "test@mail.com" }
      # }
      def index
        current_friend_ids = current_user.friends.pluck(:id)
        target_friend_ids  = @target.friends.pluck(:id)
        mutual_ids         = current_friend_ids & target_friend_ids
        mutual_friends     = User.where(id: mutual_ids)

        render json: mutual_friends.as_json(only: [ :id, :name, :email, :user_name ]), status: :ok
      end

      private

      def find_target_user
        target_params = params.require(:target).permit(:email, :user_name, :username)
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
