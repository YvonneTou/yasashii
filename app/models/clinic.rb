class Clinic < ApplicationRecord
  has_many :connections
  has_many :messages, as: :sender
  has_one_attached :photo
end
