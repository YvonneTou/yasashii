class DashboardsController < ApplicationController
  skip_after_action :verify_authorized, only: :show

  def show
    @user_connections = policy_scope(current_user.connections)
    # authorize @user_connections
  end
end
