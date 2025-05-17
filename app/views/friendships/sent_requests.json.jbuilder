# frozen_string_literal: true

json.message "Fetched received friend requests"

json.data @sent_requests do |request|
  json.extract! request, :id, :status, :created_at, :updated_at
  json.receiver_id request.receiver.id
  json.username request.receiver.username
  json.avatar_url request.receiver.avatar_url
  json.name request.receiver.name
  json.location request.receiver.location
end
