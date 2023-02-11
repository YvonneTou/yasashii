class Clinic < ApplicationRecord
  has_many :connections
  has_many :messages, as: :sender
  acts_as_taggable_on :specialties
end
