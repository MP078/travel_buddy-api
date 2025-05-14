# frozen_string_literal: true

json.message "User details fetched successfully"

json.data @user, partial: 'users/user', as: :user
