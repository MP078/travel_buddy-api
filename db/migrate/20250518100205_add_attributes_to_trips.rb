# frozen_string_literal: true

class AddAttributesToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :travel_guide, :jsonb, default: {}
  end
end
