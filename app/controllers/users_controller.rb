# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index update photos]
  before_action :set_user, only: :show

  def index
    if params[:all]=="true"
      @users = User.where.not(id: [current_user.id] + current_user.friends.pluck(:id))
      return
    elsif params[:suggested]=="true"
      @users = User.similar_to(current_user)
      @users = @users.where.not(id: [current_user.id] + current_user.friends.pluck(:id))
      return
    end
    @user = current_user
    if @user.nil?
      render json: { error: "User not found" }, status: :not_found
    else
      render :index, status: :ok
    end
  end

  def show
    if @user.nil?
      render json: { error: "User not found" }, status: :not_found
    else
      render :show, status: :ok
    end
  end

  def update
    if current_user.update!(user_params)
      render :show, status: :ok, location: @user = current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def photos
    user = if params[:username].present?
      User.find_by(username: params[:username])
    else
      current_user
    end

    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    photos = user.posts.includes(images_attachments: :blob).flat_map do |post|
      post.images.map { |image| url_for(image) }
    end

    render json: { message: "User photos retrieved successfully", data: photos }
  end


  private
    def set_user
      @user = User.find_by(username: params[:username])
    end

    def user_params
      params.permit(:name, :avatar, :username, :location, :website, :bio, :about, languages: [], interests: [], certifications: [])
    end
end
