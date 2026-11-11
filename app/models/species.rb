class Species < ApplicationRecord
  has_many :patients

  validates :common_name, presence: true, uniqueness: true
  validates :scientific_name, presence: true
end
