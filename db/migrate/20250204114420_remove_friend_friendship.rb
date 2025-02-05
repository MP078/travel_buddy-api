class RemoveFriendFriendship < ActiveRecord::Migration[8.0]
  def change
    # Removing foreign keys
    remove_foreign_key :friend_requests, column: :receiver_id
    remove_foreign_key :friend_requests, column: :sender_id
    remove_foreign_key :friendships, column: :user_id
    remove_foreign_key :friendships, column: :friend_id

    # Dropping the tables
    drop_table :friend_requests do |t|
      t.index [ "receiver_id" ], name: "index_friend_requests_on_receiver_id"
      t.index [ "sender_id", "receiver_id" ], name: "index_friend_requests_on_sender_id_and_receiver_id", unique: true
      t.index [ "sender_id" ], name: "index_friend_requests_on_sender_id"
      t.index [ "status" ], name: "index_friend_requests_on_status"
    end

    drop_table :friendships do |t|
      t.index [ "friend_id" ], name: "index_friendships_on_friend_id"
      t.index [ "user_id", "friend_id" ], name: "index_friendships_on_user_id_and_friend_id", unique: true
      t.index [ "user_id" ], name: "index_friendships_on_user_id"
    end
  end
end
