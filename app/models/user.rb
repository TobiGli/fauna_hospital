class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum role: { auxiliary: 0, veterinarian: 1, admin: 2 }, _default: "auxiliary"
end
