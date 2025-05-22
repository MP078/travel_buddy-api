# frozen_string_literal: true

class AddPdfStatsToDestinations < ActiveRecord::Migration[8.0]
  def change
    add_column :destinations, :pdf_views, :integer
    add_column :destinations, :pdf_downloads, :integer
  end
end
