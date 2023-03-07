class MessagesController < ApplicationController
  require "vonage"
  require "json"
  require "open-uri"

  def create
    @connection = Connection.find(params[:connection_id])
    @message = Message.new(message_params)
    authorize @message
    @message.connection = @connection
    @message.sender = current_user
    if @message.save
      update_ncco
      redirect_to connection_path(@connection, no_call: true)
      # ConnectionChannel.broadcast_to(
      #   @connection,
      #   @message.content
      # )
    else
      render "connections/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
