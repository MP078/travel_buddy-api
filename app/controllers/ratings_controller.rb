# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rateable

  def create
    @rating = @rateable.ratings.find_or_initialize_by(user: current_user)
    @rating.value = rating_params[:value]

    if @rating.save
      attach_images if params[:images].present?
      render json: {
        success: true,
        average_rating: @rateable.average_rating,
        rating: {
          id: @rating.id,
          value: @rating.value,
          image_urls: @rating.images.map { |img| url_for(img) }
        }
      }, status: :created
    else
      render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def set_rateable
      klass = params[:rateable_type].to_s.camelize.constantize
      @rateable = klass.find(params[:rateable_id])
    end

    def rating_params
      params.permit(:value)
    end

    def attach_images
      params[:images].each do |img|
        @rating.images.attach(img)
      end
    end
end
