# frozen_string_literal: true

# == Schema Information
#
# Table name: post_tags
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :uuid             not null
#  tag_id     :uuid             not null
#
# Indexes
#
#  index_post_tags_on_post_id             (post_id)
#  index_post_tags_on_post_id_and_tag_id  (post_id,tag_id) UNIQUE
#  index_post_tags_on_tag_id              (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (tag_id => tags.id)
#
class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag
end
