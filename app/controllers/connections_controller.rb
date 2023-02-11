class ConnectionsController < ApplicationController
  before_action :set_clinic, only: [:create]
  def create
    @connection = Connection.new(connection_params)
    @connection.clinic = @clinic
    @connection.user = current_user
    if @connection.save
      # redirect_to connection_path(@connection)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_clinic
    @listing = Clinic.find(params[:clinic_id])
  end

  def connection_params
    params.require(:connection).permit(:appt_date, :symptoms, :info)
  end
end
