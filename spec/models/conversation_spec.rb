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
require "rails_helper"

RSpec.describe Conversation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
