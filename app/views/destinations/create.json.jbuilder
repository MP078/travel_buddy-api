# frozen_string_literal: true

json.message "Destination created successfully"
json.data @destination, partial: "destinations/destination", as: :destination
