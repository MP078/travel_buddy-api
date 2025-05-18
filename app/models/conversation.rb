# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(
      where(sender_id: recipient_id, recipient_id: sender_id)
    )
  end

  def with_user(user)
    user_id = user.is_a?(User) ? user.id : user
    sender_id == user_id ? recipient : sender
  end

  def unread_messages_count(user_id)
    messages.where(read: false).where.not(user_id: user_id).count
  end
end
