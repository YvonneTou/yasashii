class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :clinic
  has_many :messages, dependent: :destroy
  validates_presence_of :user, :symptoms, :clinic
  enum :status, [ :pending, :accepted, :rejected, :completed ]
  has_one_attached :photo
end
