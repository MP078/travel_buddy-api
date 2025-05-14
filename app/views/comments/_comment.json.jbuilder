# frozen_string_literal: true

json.extract! comment, :id, :body, :created_at, :updated_at
json.user comment.user, partial: "users/user", as: :user
json.replies comment.replies, partial: "comments/comment", as: :comment
