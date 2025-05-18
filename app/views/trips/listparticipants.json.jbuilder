# frozen_string_literal: true

json.message "Trip participants"

json.users @trip_participants, partial: "users/user", as: :user
