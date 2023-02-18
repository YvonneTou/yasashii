class VoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def answer?
    true
  end

  def event?
    true
  end
end
