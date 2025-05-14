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
  end

  def update
  end

  private
  def set_user
    @user = User.find_by(username: params[:username])
  end
end
