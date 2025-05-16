# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  id            :uuid             not null, primary key
#  rateable_type :string           not null
#  value         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rateable_id   :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_ratings_on_rateable           (rateable_type,rateable_id)
#  index_ratings_on_user_and_rateable  (user_id,rateable_type,rateable_id) UNIQUE
#  index_ratings_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  has_many_attached :images, dependent: :destroy

  validates :value, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: [:rateable_type, :rateable_id], message: "has already rated this item" }


  def images_urls
    return [] unless images.attached?
    images.map { |image| url_for(image) }
  end
end
