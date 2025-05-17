# frozen_string_literal: true

json.message "Fetched received friend requests"

json.data @sent_requests do |request|
  json.id request.requester.id
  json.username request.requester.username
  json.avatar_url request.requester.avatar_url
  json.name request.requester.name
  json.created_at request.created_at
  json.status request.status
end
