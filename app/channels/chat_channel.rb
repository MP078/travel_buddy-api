# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])
    unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
      reject
    else
      stream_for @conversation
    end
  end


  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    conversation = Conversation.find(params[:conversation_id])
    message = conversation.messages.create!(
      content: data["content"],
      user: current_user
    )

    # Broadcast the message immediately without waiting for the job
    message_json = message.as_json(only: [:id, :content, :user_id, :read, :created_at])
    ChatChannel.broadcast_to(
      conversation,
      message_json
    )

    Rails.logger.info "ChatChannel#receive: Created and broadcast message #{message.id} in conversation #{conversation.id} by user #{current_user&.id}"
  end

  def mark_as_read(data)
    conversation = Conversation.find(params[:conversation_id])
    messages = conversation.messages
               .where(read: false)
               .where.not(user_id: current_user.id)

    messages.update_all(read: true)

    ChatChannel.broadcast_to(
      conversation,
      {
        action: "messages_read",
        reader_id: current_user.id
      }
    )
  end
end
