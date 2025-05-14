# frozen_string_literal: true

json.message "Comments loaded successfully"
json.data @comments, partial: "comments/comment", as: :comment
