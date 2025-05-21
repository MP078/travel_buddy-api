class AddDetailedFieldsToRatings < ActiveRecord::Migration[7.0]
  def change
    add_column :ratings, :overall_experience, :integer
    add_column :ratings, :communication, :integer
    add_column :ratings, :reliability, :integer
    add_column :ratings, :travel_compatibility, :integer
    add_column :ratings, :respect_consideration, :integer
    add_column :ratings, :review, :text
    add_column :ratings, :recommend, :boolean
  end
end
