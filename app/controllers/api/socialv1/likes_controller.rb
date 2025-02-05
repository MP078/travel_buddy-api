module Api
  module Socialv1
    class LikesController < ApplicationController
      before_action :authenticate_user!
      before_action :find_post

      # POST /api/socialv1/likes
      # Body should contain: { "post_id": <id> }
      def create
        like = @post.likes.new(user: current_user)
        if like.save
          render json: { message: "Liked successfully", like_id: like.id }, status: :created
        else
          render json: { error: like.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/socialv1/likes
      # Body should contain: { "post_id": <id> }
      def destroy
        like = @post.likes.find_by(user: current_user)
        if like
          like.destroy
          render json: { message: "Like removed" }, status: :ok
        else
          render json: { error: "Like not found" }, status: :not_found
        end
      end

      private

      def find_post
        @post = Post.find_by(id: params[:post_id])
        render json: { error: "Post not found" }, status: :not_found unless @post
      end
    end
  end
end
