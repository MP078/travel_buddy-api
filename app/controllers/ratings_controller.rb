
# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rateable, only: [:create]

  # GET /ratings?username=some_username
  def index
    user = User.find_by!(username: params[:username])
    ratings = Rating.where(rateable: user).includes(:user, images_attachments: :blob)

    render json: ratings.map { |rating|
      {
        id: rating.id,
        reviewer: {
          id: rating.user.id,
          username: rating.user.username,
          name: rating.user.name
        },
        value: rating.value,
        overall_experience: rating.overall_experience,
        communication: rating.communication,
        reliability: rating.reliability,
        travel_compatibility: rating.travel_compatibility,
        respect_consideration: rating.respect_consideration,
        review: rating.review,
        recommend: rating.recommend,
        image_urls: rating.images.map { |img| url_for(img) },
        created_at: rating.created_at
      }
    }
  end
  def create
    # [TODO] check if the user is allowed to rate this item

    # prevent self-rating
    if @rateable.is_a?(User) && @rateable.id == current_user.id
      return render json: { error: "Really? You're rating yourself, such a joke." }, status: :forbidden
    end

    @rating = Rating.find_or_initialize_by(
      user: current_user,
      rateable: @rateable
    )
    @rating.assign_attributes(rating_params)

    # Calculate value as the average of the five sub-ratings (ignoring nils)
    subratings = [
      @rating.overall_experience,
      @rating.communication,
      @rating.reliability,
      @rating.travel_compatibility,
      @rating.respect_consideration
    ].compact
    if subratings.any?
      @rating.value = (subratings.sum.to_f / subratings.size).round
    else
      @rating.value = nil
    end

    if @rating.save
      attach_images if params[:images].present?
      render json: {
        success: true,
        average_rating: @rateable.average_rating,
        rating: {
          id: @rating.id,
          overall_experience: @rating.overall_experience,
          communication: @rating.communication,
          reliability: @rating.reliability,
          travel_compatibility: @rating.travel_compatibility,
          respect_consideration: @rating.respect_consideration,
          review: @rating.review,
          recommend: @rating.recommend,
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
        Rails.logger.info "Looking up rateable: klass=#{klass}, rateable_id=#{params[:rateable_id]}"
        if klass == User && params[:rateable_id].present?
          @rateable = klass.find_by!(username: params[:rateable_id])
        else
          @rateable = klass.find(params[:rateable_id])
        end
      end

      def rating_params
        params.permit(:value, :overall_experience,
          :communication,
          :reliability,
          :travel_compatibility,
          :respect_consideration,
          :review,
          :recommend,)
      end

      def attach_images
        params[:images].each do |img|
          @rating.images.attach(img)
        end
      end
end
