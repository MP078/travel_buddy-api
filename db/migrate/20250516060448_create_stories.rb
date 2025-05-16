# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[8.0]
  def change
    create_table :stories, id: :uuid do |t|
      t.string :caption
      t.string :location
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
