class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save
    create_message("answered")
    greeting(@connection)
  end

  def event
    input = params['dtmf']['digits'] if params['dtmf']
    # speech = params['speech']['results'][0]['text'] if params['speech']
    status = params['status'] if params['status']

    # ConnectionChannel.broadcast_to(
    #   @connection,
    #   "event"
    # )

    create_message("call ended") if status == "completed"
    end_call if status == "completed"

    render json: [
      # talk_json("ご受諾いただき、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。失礼いたします。")
      talk_json("どうも")
    ].to_json
  end

  private

  def set_connection
    if params[:connection_id]
      @connection = Connection.find(params[:connection_id])
    else
      @connection = Connection.find_by(uuid: params['uuid'])
    end
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
      head: 302,
      path: "#{connection_path(@connection)}?no_call=true"
    )
  end

  def end_call
    ConnectionChannel.broadcast_to(
      @connection,
      head: 302,
      path: dashboard_path
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
      eventUrl: ["https://57c3-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}"]
    }
  end

  # call paths

  def greeting(connection)
    name = "#{connection.user.firstname} #{connection.user.lastname}"
    appt_date = @connection.appt_date.strftime("%Y年%m月%d日%H時%M分")
    symptoms = @connection.symptoms
    info = @connection.info

    render json: [
      talk_json(greeting_text(name, appt_date, symptoms, info)),
      input_json(greeting_number),
      event_json
    ]
  end

  def greeting_text(name, appt_date, symptoms, info)
    # "こんにちは。「ヤサシイアプリ」からの予約の依頼でございます。アプリで入力された詳細をお伝えいたします。予約者の名前は「#{name}」でございます。希望の日時は「#{appt_date}」でございます。現在、予約者の苦しんでいる症状は「#{symptoms.each { |symptom| "#{DeepL.translate symptom, 'EN', 'JA'}," }}」でございます。最後に、予約者からのコメントをお伝えいたします。「#{DeepL.translate info, 'EN', 'JA'}」"
    name
  end

  def greeting_number
    # "こちらの予約をご受諾の場合は、番号と番号記号をご入力ください。"
    "番号プリーズ"
  end
end
