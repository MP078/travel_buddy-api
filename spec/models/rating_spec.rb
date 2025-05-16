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
require "rails_helper"

RSpec.describe Rating, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
