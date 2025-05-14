# frozen_string_literal: true

json.message "Comments loaded successfully"
json.array! @comments, partial: "comments/comment", as: :comment
