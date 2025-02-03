class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

    # ACTIVESTORAGE
    # has_one_attached :avatar, dependent: :destroy

    # associations
    # trip association
    has_many :trips, dependent: :destroy # user created trips
    has_many :trip_memberships, dependent: :destroy   # Trips the user has joined
    has_many :joined_trips, through: :trip_memberships, source: :trip # Trips the user has joined


    # validations
    validates :password_confirmation, presence: { message: "must be present" }, on: [ :create, :update ]
    validates :name, presence: true
    validates :user_name, presence: true
    validates :address, presence: true
    validates :phone_number, presence: true
    validates :bio, length: { maximum: 500 }, allow_blank: true
    validates :avatar, presence: true, if: :avatar_required?

  private

  def avatar_required?
    false
  end
end
