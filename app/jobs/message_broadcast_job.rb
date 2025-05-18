# frozen_string_literal: true

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Use ChatChannel instead of direct broadcast
    ChatChannel.broadcast_to(
      message.conversation,
      {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        read: message.read,
        created_at: message.created_at.iso8601,
        user: {
          id: message.user.id,
          name: message.user.name,
          username: message.user.username
        }
      }
    )
  end
end
