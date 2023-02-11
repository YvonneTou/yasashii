class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :clinic
  has_many :messages, dependent: :destroy
  enum :status, [ :pending, :accepted, :rejected, :completed ]

end
