# frozen_string_literal: true

class DestinationsController < ApplicationController
  before_action :set_destination, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create]

  def index
    @destinations = Destination.all
  end

  def show
  end

  def create
    @destination = Destination.new(destination_params)

    if @destination.save
      render :create, status: :created
    else
      render json: { errors: @destination.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @destination.update(destination_params)
      render :show
    else
      render json: { errors: @destination.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @destination.destroy
    head :no_content
  end

  private
    def set_destination
      @destination = Destination.find(params[:id])
    end

    def destination_params
      params.permit(
        :name, :location, :description, :difficulty,
        :best_time_to_visit, :average_cost,
        :image,
        travel_guide: {},
        activities: [], highlights: [], travel_tips: []
      )
    end
end
