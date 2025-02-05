module Api
  module Socialv1
    class FriendSearchController < ApplicationController
      before_action :authenticate_user!

      # GET /api/socialv1/friend_search?query=search_term
      def index
        query = params[:query]
        if query.blank?
          return render json: { error: "Query parameter is required" }, status: :unprocessable_entity
        end

        # Search by name, email, or user_name
        results = User.where("name ILIKE :q OR email ILIKE :q OR user_name ILIKE :q", q: "%#{query}%")
                      .where.not(id: current_user.id)

        render json: results.as_json(only: [ :id, :name, :email, :user_name ]), status: :ok
      end
    end
  end
end
