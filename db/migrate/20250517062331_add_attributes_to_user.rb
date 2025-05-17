# frozen_string_literal: true

class AddAttributesToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :languages, :string, array: true, default: []
    add_column :users, :interests, :string, array: true, default: []
    add_column :users, :certifications, :string, array: true, default: []
  end
end
