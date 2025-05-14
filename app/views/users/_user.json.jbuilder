# frozen_string_literal: true

json.extract! user, :id, :username, :email, :name, :verified
json.profile_image user.avatar_url
