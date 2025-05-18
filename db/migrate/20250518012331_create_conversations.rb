# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :sender, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :recipient, type: :uuid, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :conversations, [:sender_id, :recipient_id], unique: true
  end
end
