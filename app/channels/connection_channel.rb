class ConnectionChannel < ApplicationCable::Channel
  def subscribed
    connection = Connection.find(params[:id])
    stream_for connection
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
