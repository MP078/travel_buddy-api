# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :uuid             not null, primary key
#  content         :text             not null
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (user_id => users.id)
#

class Message < ApplicationRecord
  after_create_commit :broadcast_message
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  # Include the user when fetching messages
  def as_json(options = {})
    super(options.merge(
      include: { user: { only: [:id, :name, :username] } },
      except: [:updated_at]
    ))
  end

  private
    def broadcast_message
      MessageBroadcastJob.perform_later(self)
    end
end
