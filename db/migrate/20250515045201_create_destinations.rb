# frozen_string_literal: true

class CreateDestinations < ActiveRecord::Migration[8.0]
  def change
    create_table :destinations, id: :uuid do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :description
      t.string :difficulty, default: "easy"
      t.string :best_time_to_visit
      t.string :highlights, array: true, default: []
      t.string :activities, array: true, default: []
      t.string :travel_tips, array: true, default: []
      t.string :average_cost
      t.timestamps
    end
  end
end
