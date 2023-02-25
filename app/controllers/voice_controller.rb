class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    render json: [
      {
          "action": "talk",
          "text": "こちらの予約をご受諾の場合は、番号をご入力くださいませ。",
          "language": "ja-JP",
          "style": 0,
          "bargeIn": false
      },
      {
          "action": "input",
          "type": ["dtmf", "speech"],
          "dtmf": {
              "submitOnHash": true,
              "timeOut": 10,
              "maxDigits": 1
          },
          # "speech": {
          #   "language": "ja-JP",
          #   "endOnSilence": 0.5,
          #   "saveAudio": true
          # },
          "eventUrl": ["https://c627-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}"]
      }
    ]
  end

  def event
    number = params['dtmf']['digits']
    # speech = params['speech']['results'][0]['text']

    render json: [
      talk_json(@connection.id)
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
end
