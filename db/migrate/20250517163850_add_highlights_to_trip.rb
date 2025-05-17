# frozen_string_literal: true

class AddHighlightsToTrip < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :cost, :string, default: "Rs. 0"
    add_column :trips, :highlights, :string, array: true, default: []
  end
end
