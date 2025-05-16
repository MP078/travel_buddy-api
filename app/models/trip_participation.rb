# frozen_string_literal: true

# == Schema Information
#
# Table name: trip_participations
#
#  id         :uuid             not null, primary key
#  approved   :boolean          default(FALSE), not null
#  joined_at  :datetime
#  organizer  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_trip_participations_on_trip_id              (trip_id)
#  index_trip_participations_on_user_id              (user_id)
#  index_trip_participations_on_user_id_and_trip_id  (user_id,trip_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (trip_id => trips.id)
#  fk_rails_...  (user_id => users.id)
#
class TripParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  validates :user_id, uniqueness: { scope: :trip_id, message: "has already requested to join this trip" }

  scope :approved, -> { where(approved: true) }
  scope :organizers, -> { where(organizer: true) }

  before_create :ensure_capacity_on_create
  before_update :ensure_capacity_on_approval, if: -> { approved_changed?(from: false, to: true) }



  def approve!
    update(approved: true, joined_at: Time.current)
  end

  def make_organizer!
    update(organizer: true)
  end

  def remove_organizer!
    update(organizer: false)
  end


  private
    def ensure_capacity_on_create
      if approved? && !trip.has_vacancy?
        errors.add(:base, "Trip is already full.")
        throw :abort
      end
    end

    def ensure_capacity_on_approval
      unless trip.has_vacancy?
        errors.add(:base, "Trip is already full.")
        throw :abort
      end
    end
end
