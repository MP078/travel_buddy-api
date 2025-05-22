# frozen_string_literal: true

class DestinationsController < ApplicationController
  before_action :set_destination, only: [:show, :update, :destroy, :view_pdf, :download_pdf, :upload_pdf]
  before_action :authenticate_user!, except: [:index]

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
  def upload_pdf
    @destination = Destination.find(params[:id])
    @destination.pdf.attach(params[:pdf])
    @destination.update(pdf_views: 0, pdf_downloads: 0)
    render json: { success: true }
  end

  def view_pdf
    if @destination.pdf.attached?
      @destination.increment!(:pdf_views)
      send_data @destination.pdf.download,
                filename: @destination.pdf.filename.to_s,
                type: @destination.pdf.content_type,
                disposition: "inline"
    else
      render json: { error: "PDF not found" }, status: :not_found
    end
  end

  def download_pdf
    if @destination.pdf.attached?
      @destination.increment!(:pdf_downloads)
      send_data @destination.pdf.download,
                filename: @destination.pdf.filename.to_s,
                type: @destination.pdf.content_type,
                disposition: "attachment"
    else
      render json: { error: "PDF not found" }, status: :not_found
    end
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
        :lat,
        :lng,
        :pdf,
        travel_guide: {},
        activities: [], highlights: []
      )
    end
end
