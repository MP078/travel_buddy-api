# frozen_string_literal: true

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
