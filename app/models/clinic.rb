class Clinic < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :messages, as: :sender
  has_one_attached :photo
  acts_as_taggable_on :specialties
  geocoded_by :location, params: { country: "jp", proximity: "139.817413,35.652832" }
  after_validation :geocode, if: :will_save_change_to_location?

  include PgSearch::Model
  pg_search_scope :search_by_keyword,
    against: [ :location ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
