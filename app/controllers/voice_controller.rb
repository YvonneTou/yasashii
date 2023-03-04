class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save
    # create_message("answered")
    greeting
  end

  def event
    input = params['dtmf']['digits'].to_i if params['dtmf']
    # speech = params['speech']['results'][0]['text'] if params['speech']
    status = params['status'] if params['status']
    path = params['call_paths'] if params['call_paths']

    # end_call if status == "completed"
    return unless params['call_paths']

    accept_details_decision(input, @connection) if path == ["accept", "details"]
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
      path: "#{connection_path(@connection)}",
      params: "?no_call=true"
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

  def event_json(max_digits, call_paths)
    call_paths_string = ""
    call_paths.each do |path|
      call_paths_string += "&call_paths%5B%5D=#{path}"
    end

    {
      action: "input",
      type: ["dtmf"],
      dtmf: {
          submitOnHash: true,
          timeOut: 20,
          maxDigits: max_digits
      },
      eventUrl: ["https://57c3-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}#{call_paths_string}"]
    }
  end

  # call paths

  def greeting
    render json: [
      talk_json(greeting_text),
      input_json(greeting_number),
      event_json(1, ["accept", "details"])
    ]
  end

  def accept_details_decision(input, connection)
    puts input
    case input
    when 1
      puts "1 was pressed"
      render json: [
        talk_json(appt_details(connection))
      ]
    when 2
      puts "2 was pressed"
      render json: [
        talk_json(accepted)
      ]
    end
  end

  # text to speech

  def greeting_text
    "こんにちは。「ヤサシイアプリ」からの予約の依頼でございます。これから、ガイダンスに従い、番号を押してください。"
  end

  def greeting_number
    "予約の詳細をご確認の場合、「１」を。予約のご受諾の場合、「２」を押してください。"
  end

  def appt_details(connection)
    name = "#{connection.user.firstname} #{connection.user.lastname}"
    appt_date = connection.appt_date.strftime("%Y年%m月%d日%H時%M分")
    info = DeepL.translate @connection.info, 'EN', 'JA'
    symptoms = ""
    @connection.symptoms.each_with_index do |symptom, i|
      if i + 1 == connection.symptoms.size
        symptoms += "#{DeepL.translate symptom, 'EN', 'JA'}"
      else
        symptoms += "#{DeepL.translate symptom, 'EN', 'JA'}、"
      end
    end

    "予約者の名前は「#{name}」でございます。希望の日時は「#{appt_date}」でございます。現在、予約者の苦しんでいる症状は「#{symptoms}」でございます。最後に、予約者からのコメントをお伝えいたします。「#{info}」"
  end

  def accepted
    "ご受諾いただき、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。失礼いたします。"
  end
end
