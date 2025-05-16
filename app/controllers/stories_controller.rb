# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, only: %i[ show update destroy ]

  def index
    @friends = current_user.friends.includes(stories: :image_attachment)
    @users_with_stories = @friends.select { |friend| friend.stories.active.any? }
  end

  def show
  end

  def create
    @story = current_user.stories.new(story_params)

    if @story.save
      render :show, status: :created, location: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  def update
    if @story.update(story_params)
      render :show, status: :ok, location: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @story.destroy!
  end

  private
    def story_params
      params.permit(:caption, :location, :image)
    end
end
