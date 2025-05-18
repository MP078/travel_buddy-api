# frozen_string_literal: true

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # This job broadcasts the message to the appropriate channel
    ChatChannel.broadcast_to(
      message.conversation,
      message.as_json(only: [:id, :content, :user_id, :read, :created_at])
    )
    Rails.logger.info "Broadcasting message #{message.id} to conversation #{message.conversation_id} from user #{message.user_id}"
  end
end
