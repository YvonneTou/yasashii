class Clinic < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :messages, as: :sender
  has_one_attached :photo
  acts_as_taggable_on :specialties

  include PgSearch::Model
  pg_search_scope :search_by_keyword,
    against: [ :location ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
