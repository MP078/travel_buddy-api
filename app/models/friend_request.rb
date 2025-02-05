class FriendRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :receiver,  class_name: "User"

  validates :requester_id, uniqueness: { scope: :receiver_id }
end
