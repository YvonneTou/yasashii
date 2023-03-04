class AboutController < ApplicationController
  skip_before_action :authenticate_user!
  after_action :verify_authorized, except: [:show]

  def show
  end
end
