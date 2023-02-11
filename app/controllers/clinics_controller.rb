class ClinicsController < ApplicationController
  # access specialities via `specialty_list: []`

  def index
    @clinics = policy_scope(Clinic)
  end

  def show
    @clinic = Clinic.find(params[:id])
    authorize @clinic
    @connection = Connection.new
  end
end
