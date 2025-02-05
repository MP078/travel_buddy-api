class AddUniqueIndexToUsersUserName < ActiveRecord::Migration[8.0]
  def change
    # Remove any duplicate usernames if necessary before adding the unique index.
    # For instance, you might want to clean up the data manually or add code here.

    # Add a unique index on the user_name column unless it already exists.
    add_index :users, :user_name, unique: true unless index_exists?(:users, :user_name)
  end
end
