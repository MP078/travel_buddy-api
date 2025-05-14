# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target_user, only: [:create]
  before_action :set_friendship, only: [:update, :destroy]

  def index
    # Returns current user's friends (both directions)
    friends = current_user.friends_accepted_sent.map(&:receiver) +
              current_user.friends_accepted_received.map(&:requester)
    render json: friends.uniq, status: :ok
  end

  def create
    if Friendship.exists?(requester: current_user, receiver: @target_user) ||
       Friendship.exists?(requester: @target_user, receiver: current_user)
      return render json: { error: "Friendship already exists or pending" }, status: :unprocessable_entity
    end

    friendship = Friendship.new(requester: current_user, receiver: @target_user)

    if friendship.save
      render json: { message: "Friend request sent." }, status: :created
    else
      render json: { errors: friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @friendship.receiver != current_user
      return render json: { error: "Not authorized" }, status: :unauthorized
    end

    if @friendship.update(status: params[:status])
      render json: { message: "Friendship #{params[:status]}" }, status: :ok
    else
      render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @friendship.requester == current_user || @friendship.receiver == current_user
      @friendship.destroy
      render json: { message: "Friendship deleted" }, status: :ok
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  private
    def set_target_user
      @target_user = User.find_by!(username: params[:username])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    end

    def set_friendship
      @friendship = Friendship.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Friendship not found" }, status: :not_found
    end
end
