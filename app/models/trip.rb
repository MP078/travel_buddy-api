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
end
