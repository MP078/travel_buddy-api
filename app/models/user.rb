# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  about                  :text
#  allow_password_change  :boolean          default(FALSE)
#  bio                    :string
#  certifications         :string           default([]), is an Array
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  interests              :string           default([]), is an Array
#  languages              :string           default([]), is an Array
#  location               :string
#  name                   :string
#  phone                  :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  username               :string           not null
#  verified               :boolean          default(FALSE)
#  website                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar, dependent: :destroy

  has_many :sent_chat_messages, class_name: "ChatMessage", foreign_key: :sender_id, dependent: :destroy
  has_many :received_chat_messages, class_name: "ChatMessage", foreign_key: :receiver_id, dependent: :destroy


  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy # likes on posts and comments

  # Friend requests sent and received
  has_many :friend_requests_sent, -> { where(status: "pending") }, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy
  has_many :friend_requests_received, -> { where(status: "pending") },  class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy

  # Accepted friendships (from both sides)
  has_many :friends_accepted_sent, -> { where(status: "accepted") }, class_name: "Friendship", foreign_key: :requester_id
  has_many :friends_accepted_received, -> { where(status: "accepted") }, class_name: "Friendship", foreign_key: :receiver_id

  has_many :ratings, dependent: :destroy
  has_many :received_ratings, as: :rateable, class_name: "Rating", dependent: :destroy

  # Trips
  has_many :trip_participations, dependent: :destroy
  has_many :trips, through: :trip_participations

  # Stories
  has_many :stories, dependent: :destroy



  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :ensure_username

  scope :similar_to, ->(user) {
    interests_array = user.interests || []
    languages_array = user.languages || []
    about_query = user.about.to_s.split(/\W+/).reject(&:blank?).join(" | ")
    location_query = user.location.to_s

    where.not(id: user.id)
      .where(
        "
          (interests && ARRAY[?]::varchar[])
          OR (languages && ARRAY[?]::varchar[])
          OR similarity(about, ?) > 0.2
          OR to_tsvector('english', about) @@ plainto_tsquery('english', ?)
          OR location = ?
          OR to_tsvector('english', location) @@ plainto_tsquery('english', ?)
        ",
        interests_array, languages_array, user.about, about_query, user.location, location_query
      )
  }

  def friends
    (friends_accepted_sent.map(&:receiver) + friends_accepted_received.map(&:requester)).uniq
  end

  def friendship_status(other_user)
    return "self" if self == other_user
    if self.friends.include?(other_user)
      "friends"
    elsif self.friend_requests_sent.exists?(receiver: other_user)
      "sent"
    elsif self.friend_requests_received.exists?(requester: other_user)
      "received"
    else
      "none"
    end
  end

  def avatar_url
    avatar.attached? && url_for(avatar)
  end

  def joined_trips
    trip_participations.approved.includes(:trip).map(&:trip)
  end

  def travel_days
    trips.sum do |trip|
      if trip.start_date && trip.end_date
        (trip.end_date - trip.start_date).to_i + 1
      else
        0
      end
    end
  end


  private
    def ensure_username
      return if self.username.present?

      base = if self.name.present?
        self.name.parameterize(separator: "_")
      elsif self.email.present?
        self.email.split("@").first.parameterize(separator: "_")
      else
        "user"
      end

      candidate = base

      while self.class.exists?(username: candidate)
        hex = SecureRandom.hex(2)
        candidate = "#{base}_#{hex}"
      end

      self.username = candidate
    end
end
