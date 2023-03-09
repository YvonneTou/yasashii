class ConnectionsController < ApplicationController
  before_action :set_clinic, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create] # do not delete
  after_action :verify_authorized, except: [:show] # needs to be updated

  require "vonage"
  require "json"
  require "open-uri"

  def show
    @connection = Connection.find(params[:id])
    authorize @connection
    @message = Message.new
    authorize @message
    @user = current_user
    trigger_call(@connection) unless params[:no_call]
  end

  def create
    @connection = Connection.new(connection_params)
    @connection.clinic = @clinic
    @connection.user = current_user
    @connection.symptoms.delete_at(0)
    authorize @connection
    if @connection.save
      create_form_message("I'd like to request an appointment on #{@connection.appt_date.strftime('%A, %B %e at %R')}.")
      redirect_to connection_path(@connection)
    else
      render "clinics/show", status: :unprocessable_entity
    end
  end

  def update
    @connection = Connection.find(params[:id])
    authorize @connection
    if @connection.update(connection_params)
      if params[:Submit]
        message = create_form_message("I'd like to request a new appointment date on #{@connection.appt_date.in_time_zone("Japan").strftime('%A, %B %e at %R')}.")
        update_ncco(params)
      elsif params[:Accept]
        message = create_form_message("That date works for me!")
        update_ncco(params)
      end
      ConnectionChannel.broadcast_to(
        @connection,
        render_to_string(partial: "connections/message", locals: { message: message, style: "msg-user float-end" })
      )
    else
      render "connections/show", status: :unprocessable_entity, no_call: true
    end
  end

  private

  def set_clinic
    @clinic = Clinic.find(params[:connection][:clinic_id])
  end

  def connection_params
    params.require(:connection).permit(:appt_date, { symptoms: [] }, :info, :clinic_id)
  end

  def create_form_message(message)
    Message.create!({
      connection: @connection,
      sender: @connection.user,
      sender_type: "User",
      content: message
    })
  end

  def create_client
    url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read

    Vonage::Client.new(
      application_id: "96063012-ae83-424a-9661-caba31c197d6",
      private_key: url
    )
  end

  def trigger_call(connection)
    client = create_client

    client.voice.create({
      to: [{
        type: 'phone',
        # number: @connection.clinic.phone_number
        number: '818068285005'
      }],
      from: {
        type: 'phone',
        number: "12013800657"
      },
      answer_url: [
        "https://ed65-124-219-136-119.jp.ngrok.io/answer?connection_id=#{connection.id}"
      ]
    })
  end

  def update_ncco(params)
    client = create_client

    if params[:Submit]
      ncco = {
        "type": 'ncco',
        "ncco": [
          talk_json("予約者はご変更を受け入れることができませんでしたので、他の日付を申し上げます。"),
          input_json("<speak>#{@connection.appt_date.in_time_zone("Japan").strftime("%m月%d日、%H時%M分")}は、どうでしょうか。変更を受け付ける場合、「１」を。もう一度ご変更を提案する場合、「２」を、押してください。<break time='10s' /></speak>"),
          event_json(1, ["accept", "new_date"])
        ]
      }
    elsif params[:Accept]
      ncco = {
        "type": 'ncco',
        "ncco": [
          talk_json("予約者は変更が受け入れました。ご受付、ありがとうございました。予約者に「ヤサシイアプリ」で通知いたします。予約者のご手配のほど、よろしくお願い申し上げます。まもなく電話が終了いたします。")
        ]
      }
    end
    puts ncco
    client.voice.transfer(@connection.uuid, destination: ncco)
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
      bargeIn: true,
      loop: 3
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
          timeOut:60,
          maxDigits: max_digits
      },
      eventUrl: ["https://ed65-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}#{call_paths_string}"]
    }
  end
end
