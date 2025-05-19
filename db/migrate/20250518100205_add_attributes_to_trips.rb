# frozen_string_literal: true

class AddAttributesToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :pins, :jsonb, default: [], array: true, comment: "Array of hashes with lat and lng, e.g. [{lat: 12.34, lng: 56.78}]"
    add_column :trips, :methods, :string, array: true, default: [], comment: "Array of strings representing the methods of transport, e.g. ['car', 'bike']"
  end
end
