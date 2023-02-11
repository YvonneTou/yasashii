class ClinicsController < ApplicationController
  # access specialities via `specialty_list: []`

  def index
    @clinics = Clinic.all
  end

  def show
    @clinic = Clinic.find(params[:id])
  end
end
