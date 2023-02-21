class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated

  def answer
    render json: [
      {
          "action": "talk",
          "text": "こんにちは。",
          "language": "ja-JP",
          "style": 0,
          "bargeIn": true
      },
      {
          "action": "talk",
          "text": "こちらの予約をご受諾の場合は、番号をご入力くださいませ。",
          "language": "ja-JP",
          "style": 0,
          "bargeIn": true
      },
      {
          "action": "input",
          "type": ["dtmf"],
          "dtmf": {
              "submitOnHash": true,
              "timeOut": 10,
              "maxDigits": 1
          },
          "eventUrl": ["https://659f-153-188-33-195.jp.ngrok.io/event"]
      }
    ]
  end

  def event
    number = params['dtmf']['digits']

    if number == '1'
      render json: [
        {
        "action": "talk",
        "text": number,
        "language": "ja-JP",
        "style": 0
        }
      ]
    else
      render json: [
        {
        "action": "talk",
        "text": "#{number}じゃない",
        "language": "ja-JP",
        "style": 0
        }
      ]
    end
  end
end
