# frozen_string_literal: true

json.extract! story, :id, :caption, :location, :user_id, :created_at, :updated_at
json.image_url story.image_url
