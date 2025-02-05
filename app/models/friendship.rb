class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, uniqueness: { scope: :friend_id }

  # Creates a friendship ensuring the lower id is stored in `user_id`
  def self.create_friendship(user1, user2)
    ids = [ user1.id, user2.id ].sort
    Friendship.create!(user_id: ids.first, friend_id: ids.last)
  end

  # Destroys the friendship record for the two users (if any)
  def self.destroy_friendship(user1, user2)
    ids = [ user1.id, user2.id ].sort
    friendship = Friendship.find_by(user_id: ids.first, friend_id: ids.last)
    friendship.destroy if friendship
  end
end
