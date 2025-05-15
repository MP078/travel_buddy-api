# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[8.0]
  def change
    create_table :friendships, id: :uuid do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :receiver,  null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :status, default: "pending"

      t.timestamps
    end

    add_index :friendships, [:requester_id, :receiver_id], unique: true
  end
end
