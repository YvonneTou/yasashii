class ConnectionsController < ApplicationController
  before_action :set_clinic, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  def show
    @connection = Connection.find(params[:id])
    authorize @connection
    @messages = policy_scope(current_user.messages)
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
    params.require(:connection).permit(:appt_date, :symptoms, :info, :clinic_id)
  end
end
