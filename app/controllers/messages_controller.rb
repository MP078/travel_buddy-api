# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      ChatChannel.broadcast_to(@message.conversation, @message)
      render json: @message.as_json(only: [:id, :content, :user_id, :read, :created_at]), status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
      unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def message_params
      params.require(:message).permit(:content)
    end
end
