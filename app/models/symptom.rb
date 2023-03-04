class Symptom < ApplicationRecord
  has_many :specialties
  has_many :clinics, through: :specialties
end
