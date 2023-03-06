class VoiceController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:answer, :event] # do not delete
  before_action :authenticate_user!, except: [:answer, :event] # needs to be updated
  before_action :skip_authorization # needs to be updated
  before_action :set_connection

  def answer
    @connection.uuid = params['uuid']
    @connection.save
    # create_message("answered #{Time.now.strftime("%h:%m")}")
    ConnectionChannel.broadcast_to(
      @connection,
      confirm_new_appt_date_message
    )
    # greeting
  end

  def event
    input = params['dtmf']['digits'].to_i if params['dtmf']
    # speech = params['speech']['results'][0]['text'] if params['speech']
    status = params['status'] if params['status']
    path = params['call_paths'] if params['call_paths']

    # end_call if status == "completed"
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
      eventUrl: ["https://ed65-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}#{call_paths_string}"]
    }
  end

  def confirm_new_appt_date_message # might need updating
    "<div class='msg-clinic rounded-4 p-3 w-80 mt-2'>
    <form class='simple_form edit_connection' id='edit_connection_#{@connection.id}' novalidate='novalidate' action='/connections/#{@connection.id}' accept-charset='UTF-8' method='post'><input type='hidden' name='_method' value='patch' autocomplete='off'><input type='hidden' name='authenticity_token' value='FtB9uEYfka668peRLy2I7_EOms2_O5XxM3IRxmoKZi01Ub0ygPCqner8CE4cKhEdHx5unHgnpwzrhPlnsbeqQg' autocomplete='off'>
      <div class=''>
      <input type='submit' name='commit' value='Yes' class='btn col-sm-6 col-lg-2 btn btn-primary' data-turbo-confirm='Are you sure?' data-disable-with='Yes'>
      <input type='submit' name='commit' value='No' class='btn col-sm-6 col-lg-2 btn btn-light ms-2' data-disable-with='No'>
      </div>
      <div class=''>
      <div class='mb-3 datetime optional connection_appt_date'><label class='form-label datetime optional col-sm-12 col-lg-12 mt-3' for='connection_appt_date'>New appointment date and time</label><div class='d-flex flex-row justify-content-between align-items-center'><input class='form-select mx-1 is-valid datetime optional' value='2023-03-23T01:24:00' type='datetime-local' name='connection[appt_date]' id='connection_appt_date'></div></div>
      <input type='hidden' name='new_appt_date' id='new_appt_date' value='true' autocomplete='off'>
      <input type='submit' name='commit' value='Submit' class='btn col-sm-12 col-lg-3 btn btn-primary mb-3' data-turbo-confirm='Propose this new date?' data-disable-with='Submit'>
      </div>
</form>      </div>"
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
      change_month
    end
  end

  def change_month
    render json: [
      # talk_json("予約の変更ですね。"),
      talk_json("てすと"),
      input_json(enter_month),
      event_json(2, ["day"])
    ]
  end

  def change_day(input)
    puts input
    @connection.appt_date = @connection.appt_date.strftime("%d/#{input}/%Y/ %H:%M:00").to_datetime
    @connection.save
    puts @connection.appt_date

    render json: [
      # talk_json("予約の変更ですね。"),
      talk_json("てすと"),
      input_json(enter_day),
      event_json(2, ["time"])
    ]
  end

  def change_time(input)
    puts input
    @connection.appt_date = @connection.appt_date.strftime("#{input}/%m/%Y/ %H:%M:00").to_datetime
    @connection.save
    puts @connection.appt_date

    render json: [
      talk_json("ご希望の時間を、"),
      input_json(enter_time),
      event_json(4, ["confirm_appt_date"])
    ]
  end

  def confirm_appt_date(input)
    puts input
    @connection.appt_date = @connection.appt_date.strftime("%d/%m/%Y/ #{input.to_s[0..1]}:#{input.to_s[2..3]}:00").to_datetime
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
      render json: [
        talk_json(accepted)
      ]
    when 2
      change_day
    end
  end

  # text to speech

  def greeting_text
    # "こんにちは。「ヤサシイアプリ」からの予約の依頼でございます。これから、ガイダンスに従い、番号を押してください。"
    "テスト"
  end

  def greeting_menu
    "予約の詳細をご確認の場合、「１」を。予約のご受諾の場合、「２」を押してください。"
  end

  def appt_details_text
    name = "#{@connection.user.firstname} #{@connection.user.lastname}"
    appt_date = @connection.appt_date.strftime("%m月%d日%H時%M分")
    info = DeepL.translate @connection.info, 'EN', 'JA'
    symptoms = ""
    @connection.symptoms.each_with_index do |symptom, i|
      if i + 1 == @connection.symptoms.size
        symptoms += "#{DeepL.translate symptom, 'EN', 'JA'}"
      else
        symptoms += "#{DeepL.translate symptom, 'EN', 'JA'}、"
      end
    end

    # "予約者の名前は「#{name}」でございます。希望の日時は「#{appt_date}」でございます。現在、予約者の苦しんでいる症状は「#{symptoms}」でございます。最後に、予約者からのコメントをお伝えいたします。「#{info}」"
    "テスト"
  end

  def appt_details_menu
    "繰り返しは「１」を。受諾は「２」を。変更は「３」を。"
  end

  def enter_month
    "ご希望の月を数字で押してください。"
  end

  def enter_day
    "ご希望の日にちを数字で押してください。"
  end

  def enter_time
    "２４時間の形式で押してください。たとえ午後１時１５分だと、「１」「３」「１」「５」を押してください。"
  end

  def check_new_date
    "ご希望の日付は「#{@connection.appt_date.strftime("%m月%d日%H時%M分")}」で間違いないでしょうか。"
  end

  def check_new_date_menu
    "この日付を予約者に通信する場合、「１」を。再入力する場合、あ「２」を押してください。"
  end

  def accepted
    # "ご受諾いただき、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。失礼いたします。"
    "テスト"
  end
end
