class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save

    render json: [
      {
          "action": "talk",
          "text": "番号をご入力くださいませ。",
          "language": "ja-JP",
          "style": 0,
          "bargeIn": false
      },
      {
          "action": "input",
          "type": ["dtmf"],
          "dtmf": {
              "submitOnHash": true,
              "timeOut": 10,
              "maxDigits": 1
          },
          "eventUrl": ["https://34fb-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}"]
      }
    ]
  end

  def event
    input = params['dtmf']['digits']
    status = check_call_status(params['uuid'])
    # speech = params['speech']['results'][0]['text']

    render json: [
      talk_json(status)
    ].to_json
  end

  private

  def set_connection
    @connection = Connection.find(params[:connection_id])
  end

  def talk_json(text)
    {
      action: "talk",
      text: text,
      language: "ja-JP",
      style: 0,
      bargeIn: false
    }
  end

  # def create_vonage_client
  #   url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read

  #   Vonage::Client.new(
  #     application_id: "96063012-ae83-424a-9661-caba31c197d6",
  #     private_key: url
  #   )
  # end
end
