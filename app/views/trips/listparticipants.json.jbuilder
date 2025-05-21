# frozen_string_literal: true

json.message "Trip participants"

json.participants @trip_participants do |participant|
  json.id participant.id
  json.user participant.user, partial: "users/user", as: :user
  json.trip participant.trip, partial: "trips/trip", as: :trip
end
