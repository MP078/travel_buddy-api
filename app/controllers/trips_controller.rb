# frozen_string_literal: true

# app/controllers/trips_controller.rb
class TripsController < ApplicationController
  before_action :authenticate_user!

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      render json: { success: true, trip: @trip }, status: :created
    else
      render json: { errors: @trip.errors.full_messages }, status: :unprocessable_entity
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
