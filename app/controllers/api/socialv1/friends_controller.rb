module Api
  module Socialv1
    class FriendsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_target_user, only: [ :show, :destroy ]

      # GET /api/socialv1/friends
      # Returns a list of current user’s friends.
      def index
        render json: current_user.friends.as_json(only: [ :id, :name, :email, :user_name, :phone_number, :address, :bio, :avatar, :gender ])
      end

      # GET /api/socialv1/friend
      # Body example:
      # { "target": { "email": "test@mail.com" } }
      # Returns a friend’s profile.
      def show
        if current_user.friends.exists?(@target.id)
          posts = @target.posts.order(created_at: :desc)
          render json: {
            friend: @target.as_json(only: [ :id, :name, :email, :user_name, :phone_number, :address, :bio, :avatar, :gender ]),
            posts: posts.as_json(only: [ :id, :content, :imgs, :created_at ])
          }, status: :ok
        else
          render json: { error: "User is not your friend" }, status: :forbidden
        end
      end

      # DELETE /api/socialv1/friend
      # Body example:
      # { "target": { "user_name": "test.user" } }
      # Unfriends (deletes the friendship between the two users).
      def destroy
        if current_user.friends.exists?(@target.id)
          Friendship.destroy_friendship(current_user, @target)
          render json: { message: "unfriended successfully" }
        else
          render json: { message: "not friends" }, status: :not_found
        end
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
