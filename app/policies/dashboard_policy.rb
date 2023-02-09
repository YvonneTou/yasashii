class DashboardPolicy < ApplicationPolicy
  attr_reader :current_user, :document

  def dashboard?
  end

end
