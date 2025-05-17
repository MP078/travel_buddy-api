# frozen_string_literal: true

json.message "Fetched received friend requests"

json.data @received_requests do |request|
  json.extract! request, :id, :status, :created_at, :updated_at
  json.sender_id request.requester.id
  json.username request.requester.username
  json.avatar_url request.requester.avatar_url
  json.name request.requester.name
  json.location request.requester.location
end
