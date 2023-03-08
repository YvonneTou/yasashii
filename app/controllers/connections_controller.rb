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
      create_form_message
      redirect_to connection_path(@connection)
    else
      render "clinics/show", status: :unprocessable_entity
    end
  end

  def update
    @connection = Connection.find(params[:id])
    authorize @connection
    if @connection.update(connection_params)
      if params[:new_appt_date]
        message = Message.create!({
          connection: @connection,
          sender: current_user,
          sender_type: "User",
          content: "I'd like to request a new appointment date on #{@connection.appt_date.in_time_zone("Japan").strftime('%A, %B %e at %R')}."
        })
        update_ncco
      end
      ConnectionChannel.broadcast_to(
        @connection,
        (render partial: "connections/message", locals: { message: message, style: "msg-user float-end" }).to_s
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

  def create_form_message
    Message.create!({
      connection: @connection,
      sender: @connection.user,
      sender_type: "User",
      content: "I'd like to request an appointment on #{@connection.appt_date.strftime('%A, %B %e at %R')}."
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

  def update_ncco
    client = create_client

    ncco = {
      "type": 'ncco',
      "ncco": [
        {
          action: "talk",
          text: @connection.appt_date.in_time_zone("Japan").strftime("%m月%d日%H時%M分"),
          language: "ja-JP",
          style: 0,
          bargeIn: true
        },
        {
          action: "talk",
          text: "受諾は「１」を。変更は「２」を。",
          language: "ja-JP",
          style: 0,
          bargeIn: true
        },
        {
          action: "input",
          type: ["dtmf"],
          dtmf: {
              submitOnHash: true,
              timeOut: 20,
              maxDigits: 1
          },
          eventUrl: ["https://ed65-124-219-136-119.jp.ngrok.io/event?connection_id=#{@connection.id}&call_paths%5B%5D=accept&call_paths%5B%5D=new_date"]
        }
      ]
    }

    client.voice.transfer(@connection.uuid, destination: ncco)
  end
end
