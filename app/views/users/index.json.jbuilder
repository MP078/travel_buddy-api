# frozen_string_literal: true

json.message "User not found" if @user.nil?
json.data @user, partial: "users/user", as: :user
