# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update destroy ]
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
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
      render :show, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    def post_params
      params.permit(:content, :start_date, :end_date, :destination, images: [])
    end

    def tags_param
      params[:tags] || []
    end
end
