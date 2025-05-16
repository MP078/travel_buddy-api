# frozen_string_literal: true

# == Schema Information
#
# Table name: trip_participations
#
#  id         :uuid             not null, primary key
#  approved   :boolean          default(FALSE), not null
#  joined_at  :datetime
#  organizer  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_trip_participations_on_trip_id              (trip_id)
#  index_trip_participations_on_user_id              (user_id)
#  index_trip_participations_on_user_id_and_trip_id  (user_id,trip_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (trip_id => trips.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe TripParticipation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
