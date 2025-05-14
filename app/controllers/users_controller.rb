# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index update]
  before_action :set_user, only: :show

  def index
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
    if user_params[:username] && User.find_by(username: user_params[:username])
      return render json: { error: "Username not available" }, status: :unprocessable_entity
    end
    if current_user.update!(user_params)
      render :show, status: :ok, location: @user = current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find_by(username: params[:username])
    end

    def user_params
      params.permit(:name, :avatar, :username)
    end
end
