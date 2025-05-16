# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                   :uuid             not null, primary key
#  activities           :string           default([]), is an Array
#  description          :string
#  difficulty           :string           default("easy"), not null
#  end_date             :date             not null
#  location             :string           not null
#  maximum_participants :integer          default(1)
#  start_date           :date             not null
#  title                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Trip < ApplicationRecord
  has_many :trip_participations, dependent: :destroy
  has_many :participants, through: :trip_participations, source: :user

  has_one_attached :cover_image, dependent: :destroy

  validates :maximum_participants, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :start_date, :end_date, presence: true
  validate :start_and_end_dates_cannot_be_in_the_past

  def start_and_end_dates_cannot_be_in_the_past
    if start_date.present? && start_date < Date.current
      errors.add(:start_date, "must be after or equal to today")
    end
    if end_date.present? && end_date < Date.current
      errors.add(:end_date, "must be after or equal to today")
    end
  end


  DIFFICULTY = {
   easy: "Easy",
    medium: "Medium",
    hard: "Hard"
  }.with_indifferent_access.freeze

  validates :title, presence: true
  validates :difficulty, inclusion: { in: DIFFICULTY.keys.map(&:to_s).map(&:downcase), message: "%{value} is not a valid difficulty" }, allow_nil: true
  before_validation { self.difficulty = difficulty&.downcase }


  def organizers
    trip_participations.organizers.includes(:user).map(&:user)
  end

  def approved_participants
    trip_participations.approved.includes(:user).map(&:user)
  end

  def add_participant(user)
    trip_participations.create(user: user)
  end

  def remove_participant(user)
    trip_participations.find_by(user: user)&.destroy
  end

  def transfer_organizer_to_oldest!
    oldest = trip_participations.approved.order(:joined_at).first
    return unless oldest

    oldest.make_organizer!
  end

  # utility method to check if the trip is full
  # Returns count of approved participants
  def approved_participant_count
    trip_participations.approved.count
  end

  # Checks if the trip has available slots
  def has_vacancy?
    return true unless maximum_participants.present?
    approved_participant_count < maximum_participants
  end

  # Returns number of available slots left
  def remaining_slots
    return Float::INFINITY unless maximum_participants.present?
    [maximum_participants - approved_participant_count, 0].max
  end

  # Can a user join? (considering approval and availability)
  def can_user_join?(user)
    return false if trip_participations.exists?(user: user) # already requested or joined
    has_vacancy?
  end

  def participation_status(user)
    participation = trip_participations.find_by(user: user)
    return "not_joined" unless participation

    if participation.approved
      "joined"
    else
      "pending"
    end
  end

  def cover_image_url
    cover_image.attached? && url_for(cover_image)
  end
end
