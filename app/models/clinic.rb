class Clinic < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :messages, as: :sender
  has_one_attached :photo
  acts_as_taggable_on :specialties
end
