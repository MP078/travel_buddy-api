# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :uuid             not null, primary key
#  caption    :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_stories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Story < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :image, presence: true
  scope :active, -> { where("created_at >= ?", 24.hours.ago) }

  def image_url
    image.attached? && url_for(image)
  end
end
