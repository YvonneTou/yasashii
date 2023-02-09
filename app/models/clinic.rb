class Clinic < ApplicationRecord
  has_many :connections
  has_many :messages, as: :sender
end
