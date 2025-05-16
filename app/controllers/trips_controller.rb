# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :authenticate_user!

  def create
    @trip = Trip.new(trip_params)

    Trip.transaction do
      if @trip.save
        @trip.trip_participations.create!(
          user: current_user,
          organizer: true,
          approved: true,
        )

        render json: { success: true, trip: @trip }, status: :created
      else
        render json: { errors: @trip.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end
  end


  private
    def trip_params
      params.permit(
        :title,
        :location,
        :start_date,
        :end_date,
        :maximum_participants,
        :description,
        :difficulty,
        activities: []
      )
    end
end
