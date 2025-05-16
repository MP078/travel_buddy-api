# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_messages
#
#  id          :uuid             not null, primary key
#  content     :text
#  read        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :uuid             not null
#  sender_id   :uuid             not null
#
# Indexes
#
#  index_chat_messages_on_receiver_id  (receiver_id)
#  index_chat_messages_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
require "rails_helper"

RSpec.describe ChatMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
