# frozen_string_literal: true

class CreateChatMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_messages, id: :uuid do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :receiver, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.text :content
      t.boolean :read

      t.timestamps
    end
  end
end
