# frozen_string_literal: true

class ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    receiver_id = params[:receiver_id]
    return render json: { error: "receiver_id required" }, status: :bad_request unless receiver_id.present?

    @messages = ChatMessage.where(
      "(sender_id = :user AND receiver_id = :receiver) OR (sender_id = :receiver AND receiver_id = :user)",
      user: current_user.id,
      receiver: receiver_id
    ).order(:created_at)

    render json: @messages
  end

  def create
    @chat_message = current_user.sent_chat_messages.build(chat_message_params)

    if @chat_message.save
      ChatChannel.broadcast_to(
        @chat_message.receiver,
        chat_message: @chat_message.as_json(include: { sender: { only: [:id, :username, :name] } })
      )

      render json: @chat_message, status: :created
    else
      render json: { errors: @chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def chat_message_params
      params.permit(:receiver_id, :content)
    end
end
