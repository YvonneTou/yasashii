class DashboardPolicy < ApplicationPolicy
  attr_reader :current_user, :document

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def dashboard?
    true
  end

end
