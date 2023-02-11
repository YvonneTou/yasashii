class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :clinic
  has_many :messages
  validates_presence_of :user, :symptomss
end
