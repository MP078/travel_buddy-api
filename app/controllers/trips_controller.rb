# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: %i[list_pending_participants]




  def list_pending_participants
    unless @trip.trip_participations.find_by(user: current_user, organizer: true)
      render json: { error: "Only the organizer can view pending participants." }, status: :forbidden and return
    end

    @trip_participants = @trip.trip_participations.includes(:user).where(approved: false)
  end

  def index
    if params[:upcoming].present? && params[:upcoming].to_s == "true"
      @trips = Trip.where("start_date >= ?", Date.today).order(start_date: :asc)
    elsif params[:username].present?
      @user = User.find_by(username: params[:username])
      @trips = @user.trips.includes(:trip_participations, :users).order(created_at: :desc)
    elsif params[:location].present?
      @trips = Trip.where(location: params[:location])
    elsif params[:activity].present?
      @trips = Trip.where("activities @> ?", "{#{params[:activity]}}")
    elsif params[:difficulty].present?
      @trips = Trip.where(difficulty: params[:difficulty])
    elsif params[:start_date].present?
      @trips = Trip.where("start_date >= ?", params[:start_date])
    elsif params[:end_date].present?
      @trips = Trip.where("end_date <= ?", params[:end_date])
    else
      @trips = Trip.all
    end
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
        :cover_image,
        :cost,
        travel_guide: {},
        activities: [],
        highlights: [],
        images: []
      )
    end

    def set_trip
      @trip = Trip.find(params[:id])
    end
end
