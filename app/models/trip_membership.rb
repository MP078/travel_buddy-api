class TripMembership < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  validates :user_id, uniqueness: { scope: :trip_id, message: "has already joined this trip" } # euta user le euta trip ek choti matrai join garna sakne

  # afno trip ma join garna namilne logic ho, afai afno trip tw by default join huna parne ho jasto
  validate :cannot_join_own_trip
  def cannot_join_own_trip
    if trip.user_id == user_id
      errors.add(:base, "You are already part of this trip as the creator.")
    end
  end
end
