# frozen_string_literal: true

# == Schema Information
#
# Table name: friendships
#
#  id           :uuid             not null, primary key
#  status       :string           default("pending")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  receiver_id  :uuid             not null
#  requester_id :uuid             not null
#
# Indexes
#
#  index_friendships_on_receiver_id                   (receiver_id)
#  index_friendships_on_requester_id                  (requester_id)
#  index_friendships_on_requester_id_and_receiver_id  (requester_id,receiver_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (requester_id => users.id)
#
require "rails_helper"

RSpec.describe Friendship, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
