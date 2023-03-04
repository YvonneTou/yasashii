class ClinicsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped, only: [:index]
  # access specialities via `specialty_list: []`

  def index
    @symptoms = Symptom.all
    if params[:query].present?
      @clinics = Clinic.search_by_location_and_symptoms(params[:query])
      # @clinics.each do |clinic|
      #   clinic.symptoms.map
      # end

      # symptoms = []
      # params.each_key do |symptom|
      #   symptoms << symptom if symptom == 1
      # end
      # raise
    else
      @clinics = Clinic.all
    end
    @markers = @clinics.geocoded.map do |clinic|
      {
        lat: clinic.latitude,
        lng: clinic.longitude,
        clinic_card_html: render_to_string(partial: "pages/clinic_card", locals: { clinic: clinic }),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def show
    @clinic = Clinic.find(params[:id])
    authorize @clinic
    @connection = Connection.new

    @marker = {
      lat: @clinic.latitude,
      lng: @clinic.longitude,
      marker_html: render_to_string(partial: "show_marker")
    }
  end

  private

  def symptom_params
    params.require(:symptom).permit(:symptom)
  end

end
