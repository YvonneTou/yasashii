class Clinic < ApplicationRecord
  has_many :messages, as: :sender
end
