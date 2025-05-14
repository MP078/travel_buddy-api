# frozen_string_literal: true

json.extract! user, :id, :username, :email, :name
json.profile_image user.avatar_url
