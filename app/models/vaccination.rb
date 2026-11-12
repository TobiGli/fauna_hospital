class Vaccination < ApplicationRecord
  belongs_to :patient

  before_validation :set_next_due_at, on: :create

  validates :vaccine_name, presence: true
  validates :applied_at, presence: true
  validates :next_due_at, presence: true
  validates :dose, numericality: { greater_than: 0 }, allow_nil: true
  validate :applied_at_cannot_be_in_the_future
  validate :next_due_at_cannot_precede_applied_at

  private

  def set_next_due_at
    self.next_due_at ||= applied_at&.+(1.year)
  end

  def applied_at_cannot_be_in_the_future
    return if applied_at.blank? || applied_at <= Date.current

    errors.add(:applied_at, "can't be in the future")
  end

  def next_due_at_cannot_precede_applied_at
    return if applied_at.blank? || next_due_at.blank? || next_due_at >= applied_at

    errors.add(:next_due_at, "can't be before the applied date")
  end
end
