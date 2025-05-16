# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :rateable, polymorphic: true, null: false, type: :uuid
      t.integer :value, null: false
      t.check_constraint "value BETWEEN 1 AND 5", name: "value_between_1_and_5"

      t.timestamps
    end
  end
end
