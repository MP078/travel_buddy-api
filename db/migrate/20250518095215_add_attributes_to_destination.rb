# frozen_string_literal: true

class AddAttributesToDestination < ActiveRecord::Migration[8.0]
  def change
    add_column :destinations, :lat, :float
    add_column :destinations, :lng, :float
  end
end
