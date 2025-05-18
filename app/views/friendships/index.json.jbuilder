# frozen_string_literal: true

json.message "List of Friends"

json.data @friends do |friend|
  json.id friend.id
  json.avatar_url friend.avatar_url
  json.name friend.name
  json.location friend.location if friend.location.present?
  json.username friend.username
  json.trips_together 10
end
