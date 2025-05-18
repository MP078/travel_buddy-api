# frozen_string_literal: true

class ApplicationCable::ConnectionMonitor < ApplicationCable::Channel
  # This channel is used to debug ActionCable connections
  def subscribed
    Rails.logger.info "ConnectionMonitor#subscribed - User #{current_user&.id} connected"
    stream_from "connection_monitor"
  end

  def unsubscribed
    Rails.logger.info "ConnectionMonitor#unsubscribed - User #{current_user&.id} disconnected"
  end

  def ping(data)
    Rails.logger.info "Ping received from client #{current_user&.id}: #{data}"
    transmit({ result: "pong", timestamp: Time.current.to_i })
  end
end
