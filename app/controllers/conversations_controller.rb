# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.where(sender: current_user).or(
      Conversation.where(recipient: current_user)
    ).includes(:sender, :recipient, messages: :user).order("messages.created_at DESC")

    render json: @conversations.map { |conversation|
      other_user = conversation.with_user(current_user)
      last_message = conversation.messages.order(created_at: :desc).first

      {
        id: conversation.id,
        other_user: {
          id: other_user.id,
          name: other_user.name,
          username: other_user.username,
          avatar_url: other_user.avatar_url
        },
        last_message: last_message ? {
          id: last_message.id,
          content: last_message.content,
          created_at: last_message.created_at.iso8601,
          user_id: last_message.user_id
        } : nil,
        unread_count: conversation.unread_messages_count(current_user.id),
        created_at: conversation.created_at
      }
    }
  end

  def show
    @conversation = Conversation.includes(messages: :user).find(params[:id])

    # Ensure user is part of this conversation
    unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    # Mark messages as read
    @conversation.messages
                .where(read: false)
                .where.not(user_id: current_user.id)
                .update_all(read: true)

    render json: {
      id: @conversation.id,
      other_user: @conversation.with_user(current_user).as_json(only: [:id, :name, :username]),
      messages: @conversation.messages.order(created_at: :asc).as_json(only: [:id, :content, :user_id, :read, :created_at])
    }
  end

  def create
    recipient = User.find_by!(username: params[:username])

    # Find existing conversation or create new one
    @conversation = Conversation.between(current_user.id, recipient.id).first

    if @conversation.nil?
      @conversation = Conversation.create!(
        sender: current_user,
        recipient: recipient
      )
    end

    other_user = @conversation.with_user(current_user)
    render json: {
      id: @conversation.id,
      other_user: other_user.as_json(only: [:id, :name, :username]).merge(avatar_url: other_user.avatar_url),
      messages: []
    }, status: :created
  end
end
