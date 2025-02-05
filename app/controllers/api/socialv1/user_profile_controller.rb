module Api
  module Socialv1
    class UserProfileController < ApplicationController
      before_action :authenticate_user!

      # GET /api/socialv1/my_profile
      def show
        posts = current_user.posts.order(created_at: :desc)
       # if you need profile with posts having like and comments render json: { user: current_user.as_json(only: [ :id, :name, :email, :user_name, :phone_number, :address, :bio, :avatar, :gender ]),posts: posts.as_json(only: [ :id, :content, :imgs, :created_at ], include: { likes: { only: [ :id, :user_id ] },comments: { only: [ :id, :content, :user_id ],include: { user: { only: [ :id, :name, :user_name ] } }  } }) }, status: :ok
       # this one below gives user info and posts without likes and comments
       render json: {
        user: current_user.as_json(only: [ :id, :name, :email, :user_name, :phone_number, :address, :bio, :avatar, :gender ]),
        posts: posts.as_json(only: [ :id, :content, :imgs, :created_at ])
      }, status: :ok
      end

      # PATCH/PUT /api/socialv1/my_profile
      # Allowed parameters: :name, :user_name, :phone_number, :address, :bio, :avatar, :gender
      def update
        if current_user.update(profile_params)
          render json: { message: "Profile updated", user: current_user.as_json(only: [ :id, :name, :user_name, :phone_number, :address, :bio, :avatar, :gender ]) }, status: :ok
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:user).permit(:name, :user_name, :phone_number, :address, :bio, :avatar, :gender)
      end
    end
  end
end
