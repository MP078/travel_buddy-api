# frozen_string_literal: true

if @user
  json.data @user, partial: "users/user", as: :user
elsif @users
  json.data @users, partial: "users/user", as: :user
else
  json.message "User not found"
end
