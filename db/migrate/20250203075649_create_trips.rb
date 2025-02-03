class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.string :location, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.float :longitude, null: false
      t.float :latitude, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
