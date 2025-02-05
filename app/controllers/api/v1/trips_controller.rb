class Api::V1::TripsController < ApplicationController
  respond_to :json
  before_action :authenticate_user!, only: %i[create index show destroy all_trips update join_trip unjoin_trip]

  # GET /trips (shows current user's created trips)
  def index
        created_trips = current_user.trips   # Fetch trips the user created
        joined_trips = current_user.joined_trips # Fetch trips the user joined via memberships
        @trips = (created_trips + joined_trips).uniq# Combine and deduplicate trips
        @trips = Trip.where(id: @trips.map(&:id)).includes(:user) # Fetch full trip details
        # render json: @trips, include: { user: { only: [ :name, :user_name ] } } could do this for result but doesnt say joined or created the trip

        formatted_trips = @trips.map do |trip|
          {
            **trip.as_json,
            trip_type: trip.user_id == current_user.id ? "created" : "joined",
            user: {
              name: trip.user.name,
              user_name: trip.user.user_name
            }
          }
        end

        render json: formatted_trips
  end

  # GET /trips/all_trips (shows all trips from every user)
  def all_trips
    @trips = Trip.includes(:user).all
    render json: @trips, include: { user: { only: [ :name, :user_name ] } }
  end

  # PATCH/PUT /trips/:id (update a trip; only for trips created by current user)
  def update
    @trip = current_user.trips.find_by(id: params[:id])
    if @trip
      if @trip.update(trip_params)
        render json: @trip, status: :ok
      else
        render json: { errors: @trip.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Trip not found or you are not authorized to update this trip" }, status: :not_found
    end
  end

  # GET /trips/:id (show a trip)
  # Note: The query for joined_users has been simplified to include the association as defined in the Trip model.
  def show
    # Use includes(:user, :joined_users) since joined_users is already an association on Trip.
    @trip = Trip.includes(:user, :joined_users).find_by(id: params[:id])
    if @trip.nil?
      render json: { error: "Trip not found" }, status: :not_found
      return
    end

    # Determine which view to render based on current_user's relationship to the trip.
    if current_user == @trip.user
      render_creator_view
    elsif @trip.joined_users.include?(current_user)
      render_joined_member_view
    else
      render_unjoined_user_view
    end
  end

  # POST /trips (create a trip)
  def create
    @trip = current_user.trips.create(trip_params)
    if @trip.save
      render json: @trip, include: { user: { only: [ :name, :user_name ] } }, status: :created
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/:id (delete a trip; only for trips created by current user)
  def destroy
    @trip = current_user.trips.find_by(id: params[:id])
    if @trip
      @trip.destroy
      render json: { message: "Trip deleted successfully" }, status: :ok
    else
      render json: { message: "Trip not found" }, status: :not_found
    end
  end

  # POST /trips/:id/join_trip (join a trip created by another user)
  def join_trip
    trip = Trip.find_by(id: params[:id])
    if trip.nil?
      render json: { message: "Trip not found." }, status: :not_found
    elsif trip.user_id == current_user.id
      render json: { message: "You are already part of this trip as the creator." }, status: :unprocessable_entity
    else
      membership = current_user.trip_memberships.create(trip: trip)
      if membership.persisted?
        render json: { message: "Successfully joined the trip." }, status: :ok
      else
        render json: { errors: membership.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # DELETE /trips/:id/unjoin_trip (unjoin a trip that the user has joined)
  def unjoin_trip
    trip = Trip.find_by(id: params[:id])
    if trip.nil?
      render json: { message: "Trip not found." }, status: :not_found
    elsif trip.user_id == current_user.id
      render json: { message: "You cannot leave your own trip as the creator." }, status: :unprocessable_entity
    else
      membership = current_user.trip_memberships.find_by(trip: trip)
      if membership
        membership.destroy
        render json: { message: "Successfully unjoined the trip." }, status: :ok
      else
        render json: { message: "You are not a member of this trip." }, status: :unprocessable_entity
      end
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:location, :start_date, :end_date, :longitude, :latitude, :description)
  end

  # Render view for trip creator; the creator sees full details for themselves and for each joined member.
  def render_creator_view
    render json: {
      trip: @trip,
      creator_details: user_details(@trip.user),
      joined_members: @trip.joined_users.map { |user| user_details(user) }
    }
  end

  # Render view for joined members; they see only name and username for each member (including the creator).
  def render_joined_member_view
    all_members = (@trip.joined_users + [ @trip.user ]).uniq
    render json: {
      trip: @trip,
      joined_members: all_members.map do |user|
        if user == @trip.user
          # For the creator, include email and phone if desired. Adjust as needed.
          user_details(user).merge(role: "creator")
        else
          { name: user.name, username: user.user_name }
        end
      end
    }
  end

  # Render view for unjoined users; they only see the trip details.
  def render_unjoined_user_view
    render json: { trip: @trip }
  end

  # Helper method to display full user details.
  def user_details(user)
    {
      name: user.name,
      username: user.user_name,
      email: user.email,
      phone_number: user.phone_number
    }
  end
end
