# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update destroy ]
  before_action :set_post, only: %i[ show update destroy like unlike ]

  # GET /posts
  # GET /posts.json
  def index
    if params[:all] == "true"
      @posts = Post.all.includes(:user, :tags, :comments).order(created_at: :desc)
    elsif params[:username].present?
      @user = User.find_by(username: params[:username])
      @posts = @user.posts.includes(:user, :tags, :comments).order(created_at: :desc)
    elsif params[:tag].present?
      @tag = Tag.find_by(tag: params[:tag])
      @posts = @tag.posts.includes(:user, :tags, :comments).order(created_at: :desc)
    else
      @posts = current_user.posts.includes(:user, :tags, :comments).order(created_at: :desc)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      tags_param.each do |tag_name|
        tag = Tag.find_or_create_by(tag: tag_name.strip.downcase)
        @post.tags << tag unless @post.tags.include?(tag)
      end

      render :show, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      # Synchronize tags
      new_tags = tags_param.map { |tag_name| Tag.find_or_create_by(tag: tag_name.strip.downcase) }
      @post.tags = new_tags
      render :show, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def like
    like = @post.likes.find_or_initialize_by(user: current_user)

    if like.persisted?
      render json: { liked: true, message: "Already liked" }, status: :ok
    elsif like.save
      render json: { liked: true, message: "Post liked" }, status: :created
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unlike
    like = @post.likes.find_by(user: current_user)

    if like&.destroy
      render json: { liked: false, message: "Post unliked" }, status: :ok
    else
      render json: { message: "Like not found" }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.includes(:user, :tags, :comments).find(params[:id])
    end

    def post_params
      params.permit(:content, :start_date, :end_date, :destination, images: [])
    end

    def tags_param
      params[:tags] || []
    end
end
