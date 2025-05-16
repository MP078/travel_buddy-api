# frozen_string_literal: true

json.extract! destination, :id, :name, :location, :activities, :travel_tips, :average_cost, :best_time_to_visit, :difficulty, :highlights, :description, :created_at, :updated_at

json.cover_image_url destination.cover_image_url
