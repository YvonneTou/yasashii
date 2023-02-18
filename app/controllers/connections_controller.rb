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
    @messages = policy_scope(current_user.messages)
    @user = current_user
    trigger_call(@connection)
  end

  def create
    @connection = Connection.new(connection_params)
    @connection.clinic = @clinic
    @connection.user = current_user
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
    params.require(:connection).permit(:appt_date, {symptoms: [] }, :info, :clinic_id)
  end

  def trigger_call(connection)
    url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read

    client = Vonage::Client.new(
      application_id: "96063012-ae83-424a-9661-caba31c197d6",
      private_key: url
    )

    client.voice.create({
      to: [{
        type: 'phone',
        number: connection.clinic.phone_number
      }],
      from: {
        type: 'phone',
        number: "12013800657"
      },
      answer_url: [
        "https://9c91-124-219-136-119.jp.ngrok.io/answer"
        ]
      }
    )
  end
end
