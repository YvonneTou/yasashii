class Clinic < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :messages, as: :sender
  has_many :specialties
  has_many :symptoms, through: :specialties
  has_one_attached :photo
  # acts_as_taggable_on :specialties
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :location ],
    associated_against: {
      symptoms: [:symptom_en]
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
