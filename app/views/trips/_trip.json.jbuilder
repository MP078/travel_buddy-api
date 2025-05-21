# frozen_string_literal: true

json.extract! trip, :id, :title, :location, :start_date, :end_date,
              :maximum_participants, :activities, :description, :difficulty,
              :created_at, :updated_at, :highlights, :cost, :pins, :methods
json.can_join trip.has_vacancy? && trip.can_user_join?(current_user)
json.members_count trip.approved_participant_count
json.cover_image_url trip.cover_image_url
json.participation_status trip.participation_status(current_user)
json.is_organizer trip.is_organizer?(current_user)
json.is_participant trip.is_participant?(current_user)
json.organizers trip.organizers
json.members trip.approved_participants
json.image_urls trip.image_urls
