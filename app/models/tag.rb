# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :uuid             not null, primary key
#  tag        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags

  validates :tag, presence: true, uniqueness: { case_sensitive: false }
end
