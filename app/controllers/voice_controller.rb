class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save
    create_message("Hello! Your call has been received by #{@connection.clinic.name}.")
    greeting
  end

  def event
    input = params['dtmf']['digits'].to_i if params['dtmf']
    # speech = params['speech']['results'][0]['text'] if params['speech']
    status = params['status'] if params['status']
    path = params['call_paths'] if params['call_paths']

    end_call if status == "completed"
    return unless params['call_paths']

    call_flow(path, input)
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
    @message = Message.create!(
      {
      connection: @connection,
      sender: @connection.clinic,
      sender_type: "Clinic",
      content: message_content
      }
    )

    ConnectionChannel.broadcast_to(
      @connection,
      render_to_string(partial: "connections/message", locals: { message: @message, style: "msg-clinic float-start" })
    )
  end

  def end_call
    ConnectionChannel.broadcast_to(
      @connection,
      render_to_string(partial: "connections/appointment_confirmation", locals: { connection: @connection, style: "msg-user float-end" })
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
          timeOut: 60,
          maxDigits: max_digits
      },
      eventUrl: ["https://ed65-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}#{call_paths_string}"]
    }
  end

  # call paths

  def call_flow(path, input)
    case path
    when ["accept", "details"]
      accept_details_decision(input)
    when ["repeat", "accept", "new_date"]
      repeat_accept_new_date_decision(input)
    when ["day"]
      change_day(input)
    when ["time"]
      change_time(input)
    when ["confirm_appt_date"]
      confirm_appt_date(input)
    when ["send_to_user", "new_date"]
      send_to_user_new_date_decision(input)
    when ["accept", "new_date"]
      accept_new_date_decision(input)
    end
  end

  def greeting
    render json: [
      talk_json(greeting_text),
      input_json(greeting_menu),
      event_json(1, ["accept", "details"])
    ]
  end

  def accept_details_decision(input)
    case input
    when 1
      appt_details
    when 2
      render json: [
        talk_json(accepted)
      ]
    end
  end

  def appt_details
    render json: [
      talk_json(appt_details_text),
      input_json(appt_details_menu),
      event_json(1, ["repeat", "accept", "new_date"])
    ]
  end

  def repeat_accept_new_date_decision(input)
    case input
    when 1
      appt_details
    when 2
      render json: [
        talk_json(accepted)
      ]
    when 3
      create_message("We would like to request a different appointment date. Please wait a moment while we check our schedule.")
      change_month
    end
  end

  def change_month
    render json: [
      talk_json("予約のご変更ですね。"),
      # talk_json("てすと"),
      input_json(enter_month),
      event_json(2, ["day"])
    ]
  end

  def change_day(input)
    puts input
    @connection.appt_date = @connection.appt_date.strftime("%d/#{input}/%Y/ %H:%M:00 +0900").to_datetime
    @connection.save
    puts @connection.appt_date

    render json: [
      talk_json("続きまして、"),
      # talk_json("てすと"),
      input_json(enter_day),
      event_json(2, ["time"])
    ]
  end

  def change_time(input)
    puts input
    @connection.appt_date = @connection.appt_date.strftime("#{input}/%m/%Y/ %H:%M:00 +0900").to_datetime
    @connection.save
    puts @connection.appt_date

    render json: [
      talk_json("最後に、"),
      input_json(enter_time),
      event_json(4, ["confirm_appt_date"])
    ]
  end

  def confirm_appt_date(input)
    puts input
    @connection.appt_date = @connection.appt_date.strftime("%d/%m/%Y/ #{input.to_s[0..1]}:#{input.to_s[2..3]}:00 +0900").to_datetime
    @connection.save
    puts @connection.appt_date

    render json: [
      talk_json(check_new_date),
      input_json(check_new_date_menu),
      event_json(1, ["send_to_user", "new_date"])
    ]
  end

  def send_to_user_new_date_decision(input)
    case input
    when 1
      ConnectionChannel.broadcast_to(
        @connection,
        render_to_string(partial: "connections/new_date_form", locals: { connection: @connection })
      )
      render json: [
        talk_json(data_to_user),
        hold_music
      ]
    when 2
      change_day
    end
  end

  def accept_new_date_decision(input)
    case input
    when 1
      render json: [
        talk_json(accepted)
      ]
    when 2
      rejected_appt_date
    end
  end

  def rejected_appt_date
    render json: [
      talk_json(rejected),
      input_json(enter_day),
      event_json(2, ["time"])
    ]
  end

  # text to speech

  def greeting_text
    "<speak><break time='5s' />こんにちは。「ヤサシイアプリ」からの予約の依頼でございます。これから、ガイダンスに従い、番号を押してください。</speak>"
    # "テスト"
  end

  def greeting_menu
    "予約の詳細をご確認の場合、「１」を。予約の受け付ける場合、「２」を、押してください。"
  end

  def appt_details_text
    name = "#{@connection.user.firstname} #{@connection.user.lastname}"
    appt_date = @connection.appt_date.strftime("%m月%d日、%H時%M分")
    info = DeepL.translate @connection.info, 'EN', 'JA'
    symptoms = ""
    @connection.symptoms.each_with_index do |symptom, i|
      if i + 1 == @connection.symptoms.size
        symptoms += "#{DeepL.translate symptom, 'EN', 'JA'}"
      else
        symptoms += "#{DeepL.translate symptom, 'EN', 'JA'}、"
      end
    end

    "予約者の名前は、「#{name}」、でございます。希望の日付は、「#{appt_date}」、でございます。現在、予約者の苦しんでいる症状は、「#{symptoms}」、でございます。最後に、予約者からのコメントを申し伝えます。「#{info}」"
    # "テスト"
  end

  def appt_details_menu
    "詳細をもう一度お聞きになる場合、「１」を。受け付ける場合、「２」を。ご変更は「３」を、押してください。"
  end

  def enter_month
    "ご希望の月を数字で押してください。"
  end

  def enter_day
    "ご希望の日を数字で押してください。"
  end

  def enter_time
    "ご希望の時間は、２４時制で押してください。たとえば、午後１時１５分だと、「１」「３」「１」「５」を押してください。"
  end

  def check_new_date
    "ご希望の日付は、「#{@connection.appt_date.strftime("%m月%d日%H時%M分")}」で、間違いないでしょうか。"
  end

  def check_new_date_menu
    "この日付を予約者に通信する場合、「１」を。再入力する場合、「２」を押してください。"
  end

  def data_to_user
    "予約者に通信いたします。少々お待ちください。"
  end

  def hold_music
    {
      "action": "stream",
      "streamUrl": ["https://incompetech.com/music/royalty-free/mp3-royaltyfree/Gymnopedie%20No%201.mp3"],
      "bargeIn": "false",
      "loop": "0"
    }
  end

  def rejected
    "予約者はご希望の日付ができかねますので、もう一度ご変更よろしくお願いします。"
  end

  def accepted
    "ご受付、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。"
    # "テスト"
  end
end
