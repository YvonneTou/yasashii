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
      redirect_to connection_path(@connection)
    else
      render "clinics/show", status: :unprocessable_entity
    end
  end

  private

  def set_clinic
    @clinic = Clinic.find(params[:connection][:clinic_id])
  end

  def connection_params
    params.require(:connection).permit(:appt_date, { symptoms: [] }, :info, :clinic_id)
  end

  def trigger_call(connection)
    url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read

    @client = Vonage::Client.new(
      application_id: "96063012-ae83-424a-9661-caba31c197d6",
      private_key: url
    )

    @client.voice.create({
      to: [{
        type: 'phone',
        number: '818068285005'
      }],
      from: {
        type: 'phone',
        number: "12013800657"
      },
      answer_url: [
        "https://fc7c-210-80-199-132.jp.ngrok.io/answer?connection_id=#{connection.id}"
      ]
    })
  end
end
