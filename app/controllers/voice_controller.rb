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
          "bargeIn": true
      },
      {
          "action": "input",
          "type": ["dtmf", "speech"],
          "dtmf": {
              "submitOnHash": true,
              "timeOut": 10,
              "maxDigits": 1
          },
          "speech": {
            "language": "ja-JP",
            "endOnSilence": 0.5,
            "saveAudio": true
          },
          "eventUrl": ["https://c627-124-219-136-119.jp.ngrok.io/event"]
      }
    ]
  end

  def event
    number = params['dtmf']['digits']
    speech = params['speech']['results'][0]['text']


    talk_json("ありがとうございます。")

  end

  private

  def set_connection
  end

  def talk_json(text)
    render json: [
      {
        action: "talk",
        text: text,
        language: "ja-JP",
        style: 0
        bargeIn: false
      }
    ].to_json

    # render json: [
    #   {
    #     "action": "talk",
    #     "text": speech,
    #     "language": "ja-JP",
    #     "style": 0
    #   }
    # ]


    # if number == '1'
    #   render json: [
    #     {
    #     "action": "talk",
    #     "text": number,
    #     "language": "ja-JP",
    #     "style": 0
    #     }
    #   ]
    # else
    #   render json: [
    #     {
    #     "action": "talk",
    #     "text": "#{number}じゃない",
    #     "language": "ja-JP",
    #     "style": 0
    #     }
    #   ]
    # end
  end

  def

end
