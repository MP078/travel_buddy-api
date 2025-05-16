# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips, id: :uuid do |t|
      t.string :title,  null: false
      t.string :location, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :maximum_participants, default: 1
      t.string :description
      t.string :activities, array: true, default: []
      t.string :difficulty, null: false, default: "easy"

      t.timestamps
    end
  end
end
