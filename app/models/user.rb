class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

     # ACTIVESTORAGE
     # has_one_attached :avatar, dependent: :destroy

     # validations
     validates :password_confirmation, presence: { message: "must be present" }, on: [ :create, :update ]
     validates :name, presence: true
     validates :user_name, presence: true, uniqueness: true
     validates :address, presence: true
     validates :phone_number, presence: true
     validates :bio, length: { maximum: 500 }, allow_blank: true
     validates :avatar, presence: true, if: :avatar_required?
     validates :gender, inclusion: { in: %w[male female other], message: "%{value} is not a valid gender" }

    # associations
    # trip association
    has_many :trips, dependent: :destroy # user created trips
    has_many :trip_memberships, dependent: :destroy   # Trips the user has joined
    has_many :joined_trips, through: :trip_memberships, source: :trip # Trips the user has joined

    # Friend Requests
    has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "requester_id", dependent: :destroy
    has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy

    # Friendships are stored as a single record per friendship.
    # We define a method to return all friends.
    def friends
      # Friendship records where the user is either the lower or higher id. ## mro code hainw hai has_many wala thyo fast banauna lai direct query
      friend_ids = Friendship.where("user_id = ? OR friend_id = ?", id, id)
                              .pluck(:user_id, :friend_id)
                              .flatten
                              .uniq - [ id ]
      User.where(id: friend_ids)
    end

        # A user can create many posts.
        has_many :posts, dependent: :destroy
        # A user can like many posts.
        has_many :likes, dependent: :destroy
        # A user can write many comments.
        has_many :comments, dependent: :destroy

  private

    def avatar_required?
      false
    end
end
