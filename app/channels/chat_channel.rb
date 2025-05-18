# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])
    unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
      reject
    else
      Rails.logger.info "ChatChannel#subscribed: User #{current_user.id} subscribed to conversation #{@conversation.id}"
      stream_for @conversation
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    conversation = Conversation.find(params[:conversation_id])
    conversation.messages.create!(
      content: data["content"],
      user: current_user
    )

    # Message is broadcast via after_create_commit callback
    # We don't need to manually broadcast here
  end

  def mark_as_read(data)
    conversation = Conversation.find(params[:conversation_id])
    messages = conversation.messages
               .where(read: false)
               .where.not(user_id: current_user.id)

    if messages.update_all(read: true) > 0
      # Only broadcast if messages were updated
      ChatChannel.broadcast_to(
        conversation,
        {
          action: "messages_read",
          reader_id: current_user.id
        }
      )
    end
  end
end
