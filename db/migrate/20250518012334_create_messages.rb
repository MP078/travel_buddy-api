# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.text :content, null: false
      t.references :conversation, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
