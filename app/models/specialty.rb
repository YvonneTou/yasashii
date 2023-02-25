class Specialty < ApplicationRecord
  belongs_to :symptom
  belongs_to :clinic
end
