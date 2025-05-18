# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: %i[list_pending_participants]




  def list_pending_participants
    @trip_participants = @trip.trip_participations.includes(:user).where(approved: false)
  end

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

    def set_trip
      @trip = Trip.find(params[:id])
    end
end
