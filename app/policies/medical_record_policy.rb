class MedicalRecordPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.veterinarian? || user.admin?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end
end
