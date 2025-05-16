# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_id = [params[:sender_id], params[:receiver_id]].sort.join("_")
    stream_from "chat_#{chat_id}"
  end

  def receive(data)
    sender = User.find(data["sender_id"])
    receiver = User.find(data["receiver_id"])
    message = Message.create!(
      sender: sender,
      receiver: receiver,
      body: data["body"],
      read: false
    )

    chat_id = [sender.id, receiver.id].sort.join("_")

    ActionCable.server.broadcast("chat_#{chat_id}", {
      id: message.id,
      body: message.body,
      sender_id: sender.id,
      receiver_id: receiver.id,
      created_at: message.created_at.strftime("%H:%M"),
    })
  end
end
