# frozen_string_literal: true

module Posts
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post

    def index
      @comments = @post.comments.where(parent_id: nil).includes(:user, replies: [:user])
    end

    def create
      @comment = @post.comments.build(comment_params.merge(user: current_user))

      if @comment.save
        render partial: "comments/comment", locals: { comment: @comment }, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private
      def set_post
        @post = Post.find(params[:post_id])
      end

      def comment_params
        params.permit(:body)
      end
  end
end
