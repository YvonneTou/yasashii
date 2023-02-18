class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated

  def answer
    render json: [
      {
          "action": "talk",
          "text": "こんにちは。「ヤサシイアプリ」からの予約の依頼でございます。アプリで入力された詳細をお伝えいたします。予約者の名前は「タナー・マクセル」でございます。希望の日時は「2023年02月20日13時00分」でございます。現在、予約者の苦しんでいる症状は「頭痛、熱」でございます。最後に、予約者からのコメントをお伝えいたします。「車椅子を利用します。」",
          "language": "ja-JP",
          "style": 0,
          "bargeIn": false
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
              "timeOut": 10
          }
      },
      {
        "action": 'input',
        "submitOnHash": true,
        "eventUrl": ["https://9c91-124-219-136-119.jp.ngrok.io/event"]
      }
    ]
  end



  def event
    render json: [
      {
      "action": "talk",
      "text": "ご受諾いただき、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。失礼いたします。",
      "language": "ja-JP",
      "style": 0
      }
    ]
  end
end
