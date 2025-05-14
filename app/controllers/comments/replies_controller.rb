# frozen_string_literal: true

module Comments
  class RepliesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment

    def create
      @reply = @comment.replies.build(reply_params.merge(user: current_user, commentable: @comment.commentable))

      if @reply.save
        render partial: "comments/comment", locals: { comment: @reply }, status: :created
      else
        render json: { errors: @reply.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private
      def set_comment
        @comment = Comment.find(params[:comment_id])
      end

      def reply_params
        params.permit(:body)
      end
  end
end
