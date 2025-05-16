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
require "rails_helper"

RSpec.describe Story, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
