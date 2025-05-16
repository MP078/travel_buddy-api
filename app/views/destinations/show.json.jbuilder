# frozen_string_literal: true

json.message "Destination details retrieved successfully"
json.data @destination, partial: "destinations/destination", as: :destination
