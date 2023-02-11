class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :clinic
  has_many :messages
  enum :status, [ :pending, :accepted, :rejected, :completed ]

end
