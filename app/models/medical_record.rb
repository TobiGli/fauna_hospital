class MedicalRecord < ApplicationRecord
  belongs_to :patient
  has_one_attached :xray

  validates :weight, numericality: { greater_than: 0 }, allow_nil: true
  validates :temperature, numericality: { greater_than: 0 }, allow_nil: true
end
