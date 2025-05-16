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
class Friendship < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :requester_id, uniqueness: { scope: :receiver_id }
  validate :prevent_duplicate_inverse_friendship

  enum :status, {
  pending: "pending",
  accepted: "accepted",
  rejected: "rejected"
  }, validate: true

  scope :between, ->(user1, user2) {
    where(requester: user1, receiver: user2)
    .or(where(requester: user2, receiver: user1))
  }


private
  def prevent_duplicate_inverse_friendship
    if Friendship.exists?(requester_id: receiver_id, receiver_id: requester_id)
      errors.add(:base, "Friendship already exists in opposite direction")
    end
  end
end
