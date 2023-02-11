class Clinic < ApplicationRecord
  has_many :connections
  has_many :messages, as: :sender
  has_one_attached :photo
  acts_as_taggable_on :specialties
end
