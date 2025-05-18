# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  after_create_commit :broadcast_message

  private
    def broadcast_message
      MessageBroadcastJob.perform_later(self)
    end
end
