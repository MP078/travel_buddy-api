# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                   :uuid             not null, primary key
#  activities           :string           default([]), is an Array
#  cost                 :string           default("Rs. 0")
#  description          :string
#  difficulty           :string           default("easy"), not null
#  end_date             :date             not null
#  highlights           :string           default([]), is an Array
#  location             :string           not null
#  maximum_participants :integer          default(1)
#  start_date           :date             not null
#  title                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "rails_helper"

RSpec.describe Trip, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
