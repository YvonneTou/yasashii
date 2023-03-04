class MessagesController < ApplicationController
  def create
    @connection = Connection.find(params[:connection_id])
    @message = Message.new(message_params)
    authorize @message
    @message.connection = @connection
    @message.sender = current_user
    if @message.save
      redirect_to connection_path(@connection, no_call: true)
    else
      render "connections/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
