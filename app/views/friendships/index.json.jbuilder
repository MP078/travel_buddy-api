# frozen_string_literal: true

json.message "List of Friends"

json.data @friends, partial: "users/user", as: :user, locals: { current_user: @current_user }
