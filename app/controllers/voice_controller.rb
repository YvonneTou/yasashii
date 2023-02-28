class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save

    # name = params['name']
    # appt_date = params['appt_date']
    # symptoms = params['symptoms']
    # info = params['info']

    name = "#{@connection.user.firstname} #{@connection.user.lastname}"
    appt_date = @connection.appt_date.strftime("%Y年%m月%d日%H時%M分")
    symptoms = @connection.symptoms
    info = @connection.info

    render json: [
      {
        "action": "talk",
        "text": "#{name} #{DeepL.translate info, 'EN', 'JA'}",
        "language": "ja-JP",
        "style": 0,
        "bargeIn": false
      },
      {
          "action": "talk",
          "text": "番号をご入力ください。",
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
          "eventUrl": ["https://fc7c-210-80-199-132.jp.ngrok.io/event?connection_id=#{@connection.id}"]
      }
    ]
    # check_call_status
  end

  def event
    input = params['dtmf']['digits'] if params['dtmf']
    status = params['status'] if params['status']
    # status = check_call_status(params['uuid'])
    # speech = params['speech']['results'][0]['text']

    render json: [
      talk_json("ありがとうございます。")
    ].to_json

  end

  private

  def set_connection
    @connection = Connection.find(params[:connection_id]) if params[:connection_id]
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

  def create_vonage_client
    url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read

    Vonage::Client.new(
      application_id: "96063012-ae83-424a-9661-caba31c197d6",
      private_key: url
    )
  end
end
