class DashboardsController < ApplicationController
  skip_after_action :verify_authorized, only: :show

  def show
    user_connection_unsort = policy_scope(current_user.connections)
    @user_connections = user_connection_unsort.order("appt_date DESC")

    # authorize @user_connections
  end
end
