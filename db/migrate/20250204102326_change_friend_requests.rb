class ChangeFriendRequests < ActiveRecord::Migration[8.0]
  def change
    change_column :friend_requests, :status, :string, default: "pending", null: false
    add_column :friend_requests, :resolved_at, :datetime
    add_index :friend_requests, :status
  end
end
