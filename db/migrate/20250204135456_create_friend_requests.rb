class CreateFriendRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :friend_requests do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :receiver,  null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :friend_requests, [ :requester_id, :receiver_id ], unique: true
  end
end
