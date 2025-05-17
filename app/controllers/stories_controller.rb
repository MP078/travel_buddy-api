# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, only: %i[ show update destroy ]

  def index
    @friends = current_user.friends
    @users = [current_user] + @friends
    @users_with_stories = @users.map do |user|
      user_stories = user.stories.where("created_at >= ?", 24.hours.ago)
      [user, user_stories]
    end.to_h.reject { |_, stories| stories.empty? }
    render json: @users_with_stories.map { |user, stories|
      {
      user: user.as_json(only: [:id, :username, :name], methods: [:avatar_url]),
      stories: stories.map { |story| story.as_json(methods: [:image_url]) }
      }
    }
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
