# frozen_string_literal: true

# == Schema Information
#
# Table name: destinations
#
#  id                 :uuid             not null, primary key
#  activities         :string           default([]), is an Array
#  average_cost       :string
#  best_time_to_visit :string
#  description        :string
#  difficulty         :string           default("easy")
#  highlights         :string           default([]), is an Array
#  lat                :float
#  lng                :float
#  location           :string           not null
#  name               :string           not null
#  pdf_downloads      :integer
#  pdf_views          :integer
#  travel_tips        :string           default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe Destination, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
