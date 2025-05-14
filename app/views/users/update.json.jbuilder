# frozen_string_literal: true

json.message "User data updated successfully"
json.data @user, partial: "users/user", as: :user
