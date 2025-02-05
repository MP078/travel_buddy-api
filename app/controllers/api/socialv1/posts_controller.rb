module Api
  module Socialv1
    class PostsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_post, only: [ :show, :update, :destroy ]
      before_action :authorize_post, only: [ :update, :destroy ]

      # GET /api/socialv1/posts
      # Returns posts from current user and his friends
      def index
        # Using eager loading to reduce query counts.
        friend_ids = current_user.friends.pluck(:id)
        user_ids = friend_ids + [ current_user.id ]
        posts = Post.where(user_id: user_ids).order(created_at: :desc).includes(:user, :likes, :comments)
        render json: posts.as_json(
          include: {
            user: { only: [ :id, :name, :email, :user_name ] },
            likes: { only: [ :id, :user_id ] },
            comments: {
              only: [ :id, :content, :user_id ],
              include: { user: { only: [ :id, :name, :user_name ] } }
            }
          }
        ), status: :ok
      end

      # GET /api/socialv1/posts/:id
      # Returns details for an individual post (with likes and comments).
      def show
        render json: @post.as_json(
          include: {
            user: { only: [ :id, :name, :email, :user_name ] },
            likes: { only: [ :id, :user_id ] },
            comments: {
              only: [ :id, :content, :user_id ],
              include: { user: { only: [ :id, :name, :user_name ] } }
            }
          }
        ), status: :ok
      end

      # POST /api/socialv1/posts
      def create
        post = current_user.posts.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/socialv1/posts/:id
      def update
        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/socialv1/posts/:id
      def destroy
        @post.destroy
        render json: { message: "Post deleted successfully" }, status: :ok
      end

      private

      def post_params
        params.require(:post).permit(:content, :imgs)
      end

      def find_post
        @post = Post.find_by(id: params[:id])
        render json: { error: "Post not found" }, status: :not_found unless @post
      end

      def authorize_post
        unless @post.user_id == current_user.id
          render json: { error: "Unauthorized" }, status: :forbidden
        end
      end
    end
  end
end
