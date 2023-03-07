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
    else
      render "connections/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def update_ncco
    url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read

    client = Vonage::Client.new(
      application_id: "96063012-ae83-424a-9661-caba31c197d6",
      private_key: url
    )

    ncco = {
      "type": 'ncco',
      "ncco": [
        {
          action: "talk",
          text: "受諾は「１」を。変更は「２」を。",
          language: "ja-JP",
          style: 0,
          bargeIn: true
        },
        {
          action: "input",
          type: ["dtmf"],
          dtmf: {
              submitOnHash: true,
              timeOut: 20,
              maxDigits: 1
          },
          eventUrl: ["https://ed65-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}&call_paths%5B%5D=accept&call_paths%5B%5D=new_date"]
        }
      ]
    }

    client.voice.transfer(@connection.uuid, destination: ncco)
  end
end
