class ClinicsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @clinics = policy_scope(Clinic)
  end

  def show
    authorize @clinic
    @clinic = Clinic.find(params[:id])
  end
end
