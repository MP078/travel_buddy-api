# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :commentable, polymorphic: true, null: false, type: :uuid
      t.uuid :parent_id, index: true

      t.timestamps
    end
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
