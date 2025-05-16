# frozen_string_literal: true

json.message "Destinations retrieved successfully"

json.data @destinations, partial: "destinations/destination", as: :destination
