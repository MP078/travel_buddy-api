# frozen_string_literal: true

json.message "Trips loaded successfully"
json.data @trips, partial: "trips/trip", as: :trip
