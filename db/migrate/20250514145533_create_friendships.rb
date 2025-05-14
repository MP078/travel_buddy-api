# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[8.0]
  def change
    create_table :friendships, id: :uuid do |t|
      t.references :requester, uuid: true, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :receiver, uuid: true, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :status, default: "pending"
      t.string :status

      t.timestamps
    end

    add_index :friendships, [:requester_id, :receiver_id], unique: true
  end
end
