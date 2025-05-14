# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment, only: %i[like unlike]

  def like
    @comment.likes.create(user: current_user)
    render json: { message: "Comment liked successfully" }, status: :ok
   end
  def unlike
    @comment.likes.find_by(user: current_user)&.destroy
    render json: { message: "Comment unliked successfully" }, status: :ok
  end

  private
    def set_commentable
      @comment = Comment.find(params[:id])
    end
end
