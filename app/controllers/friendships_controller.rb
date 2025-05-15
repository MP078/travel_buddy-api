# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [:accept, :reject, :destroy]
  before_action :set_target_user, only: [:create]

  def index
    friends = current_user.friends_accepted_sent.map(&:receiver) +
              current_user.friends_accepted_received.map(&:requester)
    render json: friends.uniq, status: :ok
  end

  def create
    if @target_user == current_user
      return render json: { error: "Cannot befriend yourself" }, status: :unprocessable_entity
    end

    if Friendship.exists_between?(current_user, @target_user)
      return render json: { error: "Friendship already exists or pending" }, status: :unprocessable_entity
    end

    friendship = Friendship.new(requester: current_user, receiver: @target_user)

    if friendship.save
      render json: { message: "Friend request sent." }, status: :created
    else
      render json: { errors: friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept
    if @friendship.receiver != current_user
      return render json: { error: "Not authorized" }, status: :unauthorized
    end

    if @friendship.update(status: "accepted")
      render json: { message: "Friend request accepted." }, status: :ok
    else
      render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reject
    if @friendship.receiver != current_user
      return render json: { error: "Not authorized" }, status: :unauthorized
    end

    @friendship.destroy
    render json: { message: "Friend request rejected." }, status: :ok
  end

  def destroy
    unless [@friendship.receiver_id, @friendship.requester_id].include?(current_user.id)
      return render json: { error: "Not authorized" }, status: :unauthorized
    end

    @friendship.destroy
    render json: { message: "Friendship canceled or removed." }, status: :ok
  end

  private
    def set_friendship
      @friendship = Friendship.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Friendship not found" }, status: :not_found
    end

    def set_target_user
      @target_user = User.find_by!(username: params[:username])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    end
end
