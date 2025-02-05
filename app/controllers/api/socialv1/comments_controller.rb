module Api
  module Socialv1
    class CommentsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_post, only: [ :create ]
      before_action :find_comment, only: [ :destroy ]
      before_action :authorize_comment, only: [ :destroy ]

      # POST /api/socialv1/comments
      # Body should contain: { "post_id": <id>, "content": "your comment" }
      def create
        comment = @post.comments.new(user: current_user, content: params[:content])
        if comment.save
          render json: { message: "Comment added", comment: comment }, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/socialv1/comments
      # Body should contain: { "comment_id": <id> }
      def destroy
        @comment.destroy
        render json: { message: "Comment removed" }, status: :ok
      end

      private

      def find_post
        @post = Post.find_by(id: params[:post_id])
        render json: { error: "Post not found" }, status: :not_found unless @post
      end

      def find_comment
        @comment = Comment.find_by(id: params[:comment_id])
        render json: { error: "Comment not found" }, status: :not_found unless @comment
      end

      def authorize_comment
        unless @comment.user_id == current_user.id
          render json: { error: "Unauthorized" }, status: :forbidden
        end
      end
    end
  end
end
