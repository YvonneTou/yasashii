class DashboardController < ApplicationController
  def dashboard
    @user_connections = current_user.connections
    authorize @user_connections
  end
end
