class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    if params[:query].present?
      @clinics = Clinic.search_by_keyword(params[:query])
    else
      @clinics = Clinic.all
    end
  end
end
