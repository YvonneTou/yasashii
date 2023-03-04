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

    create_message("hi6")

    render json: [
      talk_json(greeting(name, appt_date, symptoms, info)),
      input_json(greeting_number),
      event_json
    ]
  end

  def event
    input = params['dtmf']['digits'] if params['dtmf']
    # speech = params['speech']['results'][0]['text'] if params['speech']
    status = params['status'] if params['status']

    # ConnectionChannel.broadcast_to(
    #   @connection,
    #   "event"
    # )

    render json: [
      talk_json("ご受諾いただき、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。失礼いたします。")
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
      current_user,
      # render_to_string(partial: "connections/message", locals: { message: @message, style: "msg-clinic" })
      head: 302,
      path: connection_path(@connection)
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

  def event_json
    {
      action: "input",
      type: ["dtmf"],
      dtmf: {
          submitOnHash: true,
          timeOut: 10,
          maxDigits: 1
      },
      eventUrl: ["https://a482-2405-6580-8640-8d00-acf7-8d0f-dcaf-a31.jp.ngrok.io/event?connection_id=#{@connection.id}"]
    }
  end

  # call paths

  def greeting(name, appt_date, symptoms, info)
    "こんにちは。「ヤサシイアプリ」からの予約の依頼でございます。アプリで入力された詳細をお伝えいたします。予約者の名前は「#{name}」でございます。希望の日時は「#{appt_date}」でございます。現在、予約者の苦しんでいる症状は「#{symptoms.each { |symptom| "#{DeepL.translate symptom, 'EN', 'JA'}," }}」でございます。最後に、予約者からのコメントをお伝えいたします。「#{DeepL.translate info, 'EN', 'JA'}」"
  end

  def greeting_number
    "こちらの予約をご受諾の場合は、番号と番号記号をご入力ください。"
  end
end
