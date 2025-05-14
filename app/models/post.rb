# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id          :uuid             not null, primary key
#  content     :string
#  destination :string
#  end_date    :date
#  start_date  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :likes, as: :likeable, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  validates :end_date, presence: true, if: -> { start_date.present? }

  def images_urls
    return [] unless images.attached?
    images.map { |image| url_for(image) }
  end

  def likes_count
    likes.count
  end

  def liked?(user)
    likes.exists?(user_id: user.id)
  end
end
