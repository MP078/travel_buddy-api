class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :user_name, :string, null: false
    add_column :users, :address, :string, null: false
    add_column :users, :bio, :text
    add_column :users, :avatar, :string
    add_column :users, :phone_number, :string, null: false
    add_column :users, :gender, :string, null: false
  end
end
