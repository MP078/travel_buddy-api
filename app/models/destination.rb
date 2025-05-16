# frozen_string_literal: true

# == Schema Information
#
# Table name: destinations
#
#  id                 :uuid             not null, primary key
#  activities         :string           default([]), is an Array
#  average_cost       :string
#  best_time_to_visit :string
#  description        :string
#  difficulty         :string           default("easy")
#  highlights         :string           default([]), is an Array
#  location           :string           not null
#  name               :string           not null
#  travel_tips        :string           default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Destination < ApplicationRecord
  has_one_attached :image, dependent: :destroy

  DIFFICULTY = {
    easy: "Easy",
    medium: "Medium",
    hard: "Hard"
  }.with_indifferent_access.freeze

  validates :name, :location, presence: true
  validates :difficulty, inclusion: { in: DIFFICULTY.keys.map(&:to_s).map(&:downcase), message: "%{value} is not a valid difficulty" }, allow_nil: true
  before_validation { self.difficulty = difficulty&.downcase }


  def cover_image_url
    image.attached? && url_for(image)
  end
end
