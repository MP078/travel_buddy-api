class Trip < ApplicationRecord
  belongs_to :user # tripcreator
  validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :longitude, presence: true
  validates :latitude, presence: true
  validates :description, length: { maximum: 500 }, allow_blank: true

  has_many :trip_memberships, dependent: :destroy   # Users who joined the trip
  has_many :joined_users, through: :trip_memberships, source: :user # Users who joined the trip
end
