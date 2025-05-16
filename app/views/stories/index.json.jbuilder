# frozen_string_literal: true

json.message "Stories fetched"
json.data @users_with_stories do |user|
  json.user do
    json.id user.id
    json.name user.name
    json.avatar_url user.avatar_url
  end
  json.stories user.stories.active, partial: "stories/story", as: :story
end
