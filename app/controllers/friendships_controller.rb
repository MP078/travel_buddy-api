# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_receiver_user, only: [:create, :accept, :reject, :destroy]

  def index
    @friends = current_user.friends
  end

  def received_requests
    @received_requests = current_user.friend_requests_received.includes(:requester)
  end

  def sent_requests
    @sent_requests = current_user.friend_requests_sent.includes(:receiver)
  end

  def create
    existing = Friendship.between(current_user, @receiver).first

    if existing.present?
      render json: { error: "Friendship already exists or pending" }, status: :unprocessable_entity
    else
      @friendship = Friendship.create!(requester: current_user, receiver: @receiver)
      render json: @friendship, status: :created
    end
  end


  def accept
    friendship = Friendship.find_by(requester: @receiver, receiver: current_user, status: :pending)

    if friendship
      friendship.update!(status: :accepted)
      # create a conversation for the new friendship
      Conversation.create!(sender: current_user, recipient: @receiver)
      # create a message to notify the other user
      render json: friendship, status: :ok
    else
      render json: { error: "No pending request from user" }, status: :not_found
    end
  end

  def reject
    friendship = Friendship.find_by(requester: @receiver, receiver: current_user, status: :pending)

    if friendship
      friendship.update!(status: :rejected)
      render json: { message: "Friend request rejected" }, status: :ok
    else
      render json: { error: "No pending request from user" }, status: :not_found
    end
  end

  def destroy
    friendship = Friendship.find_by(requester: current_user, receiver: @receiver) ||
                 Friendship.find_by(requester: @receiver, receiver: current_user)

    if friendship
      friendship.destroy!
      render json: { message: "Friendship cancelled or removed" }, status: :ok
    else
      render json: { error: "Friendship not found" }, status: :not_found
    end
  end

  private
    def set_receiver_user
      @receiver = User.find_by!(username: params[:username])
    end
end
