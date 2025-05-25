# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        # Try session-based authentication first
        session = cookies.encrypted["_travelbuddy_api_session"]
        user_id = session && session["user_id"]
        return User.find_by(id: user_id) if user_id

        # Try token-based authentication (from params or cookie)
        token = request.params["token"] || cookies["auth_cookie"]
        Rails.logger.debug "ActionCable token: #{token.inspect}"

        if token
          begin
            data = JSON.parse(CGI.unescape(token)) rescue nil
            Rails.logger.debug "Parsed token data: #{data.inspect}"
            user = User.find_by(email: data["uid"]) if data && data["uid"]
            return user if user
          rescue => e
            Rails.logger.error "Token parse error: #{e.message}"
          end
        end

        reject_unauthorized_connection
      end
  end
end
