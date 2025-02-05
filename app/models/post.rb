class Post < ApplicationRecord
  belongs_to :user
  has_many   :likes, dependent: :destroy
  has_many   :comments, dependent: :destroy

  # In the future to attach images Active Storage:
  # has_many_attached :images
end
