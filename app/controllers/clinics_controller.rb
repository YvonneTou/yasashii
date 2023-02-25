class ClinicsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped, only: [:index]
  # access specialities via `specialty_list: []`

  def index
    @symptoms = Symptom.all
    if params[:query].present?
      @clinics = Clinic.search_by_keyword(params[:query])
    else
      @clinics = Clinic.all
    end
  end

  def show
    @clinic = Clinic.find(params[:id])
    authorize @clinic
    @connection = Connection.new
  end
end
