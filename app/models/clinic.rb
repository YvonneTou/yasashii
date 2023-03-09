class Clinic < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :messages, as: :sender
  has_many :specialties, dependent: :destroy
  has_many :symptoms, through: :specialties
  has_one_attached :photo
  # acts_as_taggable_on :specialties
  geocoded_by :location, params: { country: "jp", proximity: "139.817413,35.652832" }
  after_validation :geocode, if: :will_save_change_to_location?

  include PgSearch::Model
  pg_search_scope :search_by_location_and_symptoms,
    against: [ :location ],
    associated_against: {
      symptoms: [:symptom_en, :location]
    },
    using: {
      tsearch: { prefix: true }
    }
end
