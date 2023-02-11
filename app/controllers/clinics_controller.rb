class ClinicsController < ApplicationController
  skip_before_action :authenticate_user!
  # access specialities via `specialty_list: []`

  def index
    @clinics = policy_scope(Clinic)
  end

  def show
    @clinic = Clinic.find(params[:id])
    authorize @clinic
  end
end
