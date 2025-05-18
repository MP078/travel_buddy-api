# frozen_string_literal: true

class AddAttributesToDestination < ActiveRecord::Migration[8.0]
  def change
    add_column :destinations, :travel_guide, :jsonb, default: {}
  end
end
