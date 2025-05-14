# frozen_string_literal: true

json.extract! post, :id, :content, :destination, :start_date, :end_date, :created_at, :updated_at
json.images do
  json.array! post.images_urls do |image|
    json.image image
  end
end
json.user post.user, partial: "users/user", as: :user
json.tags post.tags, partial: "tags/tag", as: :tag
json.likes post.likes_count
json.liked post.liked?(current_user)
