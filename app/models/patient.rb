class Patient < ApplicationRecord
  belongs_to :species
  has_many :medical_records, dependent: :destroy
  has_many :vaccinations, dependent: :destroy

  validates :identifier, uniqueness: true, allow_nil: true
  validate :admission_date_cannot_be_in_the_future

  private

  def admission_date_cannot_be_in_the_future
    return if admission_date.blank? || admission_date <= Date.current

    errors.add(:admission_date, "can't be in the future")
  end
end
