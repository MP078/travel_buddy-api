# frozen_string_literal: true

class AddUniqueIndexToRatings < ActiveRecord::Migration[8.0]
  def change
    add_index :ratings, [:user_id, :rateable_type, :rateable_id], unique: true, name: "index_ratings_on_user_and_rateable"
  end
end
