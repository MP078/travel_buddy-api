# frozen_string_literal: true

class TripParticipationsController < ApplicationController
  before_action :set_trip, except: [:leave]
  before_action :set_participation, only: [:destroy, :promote, :approve]
  before_action :authorize_organizer!, only: [:promote, :approve]
  before_action :authorize_removal!, only: [:destroy]

  # Allows a user to leave a trip (delete their participation)
  def leave
    trip_participation = TripParticipation.find_by(trip_id: params[:trip_id], user_id: current_user.id)
    unless trip_participation
      render json: { error: "You are not a participant in this trip." }, status: :not_found
      return
    end

    was_organizer = trip_participation.organizer?
    trip = trip_participation.trip
    trip_participation.destroy

    if was_organizer
      organizers_left = trip.trip_participations.where(organizer: true)
      if organizers_left.empty?
        oldest = trip.trip_participations.order(:joined_at).first
        if oldest
          oldest.update(organizer: true)
        else
          trip.destroy
          render json: { message: "You left and no one was left, so the trip was deleted." }, status: :ok
          return
        end
      end
    end

    render json: { message: "You have left the trip." }, status: :ok
  end

  def create
    if @trip.trip_participations.exists?(user: current_user)
      render json: { error: "You have already requested to join or are already a participant." }, status: :unprocessable_entity
      return
    end
    participation = @trip.trip_participations.build(
      user: current_user,
      organizer: false,
      approved: false,
      joined_at: DateTime.current
    )

    if participation.save
      render json: participation, status: :created
    else
      render json: { errors: participation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    unless @trip.trip_participations.exists?(user: current_user, organizer: true)
      render json: { error: "Only organizers can remove participants." }, status: :forbidden
      return
    end

    @participation.destroy
    render json: { message: "Participation removed." }, status: :ok
  end

  def promote
    if @participation.organizer?
      render json: { error: "This user is already an organizer." }, status: :unprocessable_entity
      return
    end
    if @participation.update(organizer: true)
      render json: { message: "User promoted to organizer." }
    else
      render json: { errors: @participation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def approve
    if @participation.approved?
      render json: { error: "This user is already approved." }, status: :unprocessable_entity
      return
    end
    if @participation.update(approved: true)
      render json: { message: "User approved to join trip." }
    else
      render json: { errors: @participation.errors.full_messages }, status: :unprocessable_entity
    end
  end

# def leave
#   participation = @trip.trip_participations.find_by(user: current_user)
#   unless participation
#     render json: { error: "You are not a participant in this trip." }, status: :not_found
#     return
#   end

#   was_organizer = participation.organizer?
#   participation.destroy

#   if was_organizer
#     organizers_left = @trip.trip_participations.where(organizer: true)
#     if organizers_left.empty?
#       oldest = @trip.trip_participations.order(:joined_at).first
#       if oldest
#         oldest.update(organizer: true)
#       else
#         @trip.destroy
#         render json: { message: "You left and no one was left, so the trip was deleted." }, status: :ok
#         return
#       end
#     end
#   end

#   render json: { message: "You have left the trip." }, status: :ok
# end

private
  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_participation
    @participation = @trip.trip_participations.find(params[:id])
  end

  def authorize_organizer!
    unless @trip.trip_participations.exists?(user: current_user, organizer: true)
      render json: { error: "Only organizers can perform this action." }, status: :forbidden
    end
  end

  def authorize_removal!
    unless current_user == @participation.user || @trip.trip_participations.exists?(user: current_user, organizer: true)
      render json: { error: "You are not authorized to remove this participation." }, status: :forbidden
    end
  end
end
