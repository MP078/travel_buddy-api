# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])
    stream_for conversation
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

    # Message is broadcasted via after_create_commit callback
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
