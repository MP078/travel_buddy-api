# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :content
      t.string :destination
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
