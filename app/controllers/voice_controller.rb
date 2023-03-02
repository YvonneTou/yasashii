class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save

    name = "#{@connection.user.firstname} #{@connection.user.lastname}"
    appt_date = @connection.appt_date.strftime("%Y年%m月%d日%H時%M分")
    symptoms = @connection.symptoms
    info = @connection.info

    create_message("hi")

    render json: [
      talk_json(greeting(name, info)),
      input_json(greeting_number),
      event_json(@connection_id, nil)
    ]
  end

  def event
    input = params['dtmf']['digits'] if params['dtmf']
    # speech = params['speech']['results'][0]['text'] if params['speech']
    status = params['status'] if params['status']


    ConnectionChannel.broadcast_to(
      @connection,
      "event"
    )
    # head :ok


    render json: [
      talk_json("ありがとうございます。")
    ].to_json

  end

  private

  def set_connection
    @connection = Connection.find(params[:connection_id]) if params[:connection_id]
  end

  def create_message(message_content)
    @message = Message.create!({
      connection: @connection,
      sender: @connection.clinic,
      sender_type: "Clinic",
      content: message_content
    })

    ConnectionChannel.broadcast_to(
      @connection,
      render_to_string(partial: "connections/message", locals: { message: @message, style: "msg-clinic" })
    )
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

  def input_json(text)
    {
      action: "talk",
      text: text,
      language: "ja-JP",
      style: 0,
      bargeIn: true
    }
  end

  def event_json(connection_id, event_params)
    {
      action: "input",
      type: ["dtmf"],
      dtmf: {
          submitOnHash: true,
          timeOut: 10,
          maxDigits: 1
      },
      eventUrl: ["https://fc7c-210-80-199-132.jp.ngrok.io/event?connection_id=#{@connection.id}"]
    }
  end

  # call paths

  def greeting(name, info)
    "#{name} #{DeepL.translate info, 'EN', 'JA'}"
  end

  def greeting_number
    "番号をご入力ください。"
  end
end
