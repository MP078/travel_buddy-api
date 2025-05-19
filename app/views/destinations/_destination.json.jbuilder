# frozen_string_literal: true

json.extract! destination, :id, :name, :location, :activities, :travel_tips, :average_cost, :best_time_to_visit, :difficulty, :highlights, :description, :created_at, :updated_at, :lat,:lng

json.cover_image_url destination.cover_image_url

json.rating destination.average_rating
json.ratings_count destination.ratings.count
json.rated current_user ? destination.rated?(current_user) : false
json.popularity destination.popularity
