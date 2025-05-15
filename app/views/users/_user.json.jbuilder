# frozen_string_literal: true

json.extract! user, :id, :username, :email, :name, :verified
json.friendship_status current_user.friendship_status(user) if current_user
json.profile_image user.avatar_url
