# frozen_string_literal: true

class CreateTripParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_participations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :trip, null: false, foreign_key: true, type: :uuid

      t.boolean :organizer, null: false, default: false
      t.boolean :approved, null: false, default: false
      t.datetime :joined_at

      t.timestamps
    end
    add_index :trip_participations, [:user_id, :trip_id], unique: true
  end
end
