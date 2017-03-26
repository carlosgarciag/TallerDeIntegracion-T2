class Usuario < ApplicationRecord
  validates :usuario, presence: true, uniqueness: true
  validates :nombre, presence: true
end
