class ChangeStartDateAndEndDateToDateFrmDatetime < ActiveRecord::Migration[8.0]
  def change
    change_column :trips, :start_date, :date
    change_column :trips, :end_date, :date
  end
end
