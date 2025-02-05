module Api
  module Socialv1
    class FriendSuggestionsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/socialv1/friend_suggestions
      def index
        # Exclude current user and those already connected or in a pending request.
        friend_ids = current_user.friends.pluck(:id)
        pending_ids = FriendRequest.where("requester_id = ? OR receiver_id = ?", current_user.id, current_user.id)
                                    .pluck(:requester_id, :receiver_id)
                                    .flatten
                                    .uniq
        excluded_ids = (friend_ids + pending_ids + [ current_user.id ]).uniq

        # Candidates are users who are not yet connected
        candidates = User.where.not(id: excluded_ids)

        # Calculate mutual friends count for each candidate.
        suggestions = candidates.map do |candidate|
          mutual_count = (current_user.friends.pluck(:id) & candidate.friends.pluck(:id)).count
          {
            id: candidate.id,
            name: candidate.name,
            email: candidate.email,
            user_name: candidate.user_name,
            mutual_friends_count: mutual_count
          }
        end

        # Sort suggestions by the number of mutual friends (highest first)
        sorted_suggestions = suggestions.sort_by { |suggestion| -suggestion[:mutual_friends_count] }
        render json: sorted_suggestions, status: :ok
      end
    end
  end
end
