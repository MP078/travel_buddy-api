# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :authenticate_user!




  def list_pending_participants
    trips = Trip.joins(:trip_participations)
                .where(trip_participations: { user_id: current_user.id, organizer: true })

    @trip_participants = TripParticipation.includes(:user, :trip)
                                          .where(trip: trips, approved: false)

    render "trips/listparticipants"
  end

  def index
    if params[:upcoming].present? && params[:upcoming].to_s == "true" && params[:user_trips] == "false"
      @trips = Trip.where("start_date > ?", Date.today).where.not(id: current_user.trips.pluck(:id)).order(start_date: :asc)
    elsif params[:upcoming].present? && params[:upcoming].to_s == "true"
      @trips = Trip.where("start_date >= ?", Date.today).order(start_date: :asc)
    elsif params[:username].present?
      @user = User.find_by(username: params[:username])
      @trips = @user.trips.includes(:trip_participations, :users).order(created_at: :desc)

      render json: {
        message: "Trips loaded successfully",
        data: @trips.map { |trip|
          is_organizer = trip.is_organizer?(@user)
          # Build the list array: username and trip_participation_id for each member
          list = trip.trip_participations.includes(:user).map do |tp|
            {
              username: tp.user.username,
              trip_participation_id: tp.id
            }
          end

          # Existing trip serialization (add your fields as needed)
          trip_hash = trip.as_json(
            only: [
              :id, :title, :location, :start_date, :end_date, :maximum_participants, :activities, :description, :difficulty, :created_at, :updated_at, :highlights, :cost, :pins, :methods
            ]
          )
          trip_hash["can_join"] = trip.can_user_join?(@user)
          trip_hash["members_count"] = trip.users.count
          trip_hash["cover_image_url"] = trip.cover_image_url
          trip_hash["participation_status"] = trip.participation_status(@user)
          trip_hash["is_organizer"] = is_organizer
          trip_hash["is_participant"] = trip.is_participant?(@user)
          trip_hash["organizers"] = trip.organizers.map { |org| org.as_json }
          trip_hash["members"] = trip.users.map { |member| member.as_json }
          trip_hash["image_urls"] = trip.image_urls
          trip_hash["list"] = list if is_organizer
          trip_hash
        }
      }
      nil
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
        pins: [:lat, :lng], # <-- This line changed!
        methods: [],
        activities: [],
        highlights: [],
        images: []
      )
    end
end
