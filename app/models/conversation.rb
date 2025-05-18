# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :uuid             not null
#  sender_id    :uuid             not null
#
# Indexes
#
#  index_conversations_on_recipient_id                (recipient_id)
#  index_conversations_on_sender_id                   (sender_id)
#  index_conversations_on_sender_id_and_recipient_id  (sender_id,recipient_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (recipient_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
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
