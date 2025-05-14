# frozen_string_literal: true

json.message "Posts fetched successfully"
json.data @posts, partial: "posts/post", as: :post
