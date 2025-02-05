# db/migrate/20250204001000_create_posts.rb
class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.text       :content, null: false
      t.string     :imgs    # (For multiple images, you might later use Active Storage or a serialized array.)
      t.references :user,    null: false, foreign_key: true
      t.timestamps
    end
    add_index :posts, :user_id
  end
end
