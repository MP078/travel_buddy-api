# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        # For cookie-based authentication
        if cookies.encrypted[:user_id]
          User.find_by(id: cookies.encrypted[:user_id])
        elsif env["warden"] && env["warden"].user
          env["warden"].user
        else
          reject_unauthorized_connection
        end
      end
  end
end
