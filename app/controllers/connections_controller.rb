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
        add_parameters(connection)
      ]
    })
  end

  def add_parameters(connection)
    param_string = "?connection_id=#{connection.id}"
    param_string += "&name=#{connection.user.firstname}%20#{connection.user.lastname}"
    param_string += "&appt_date=#{connection.appt_date.strftime("%Y-%m-%d-%H%M")}"

    connection.symptoms.each do |symptom|
      param_string += "&symptoms%5B%5D=#{symptom.gsub(' ', '%20')}"
    end

    param_string += "&info=#{connection.info.gsub(' ', '%20')}" if connection.info.empty? == false

    'https://34fb-124-219-136-119.jp.ngrok.io/answer' + param_string
  end
end
