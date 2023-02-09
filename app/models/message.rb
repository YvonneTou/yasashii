class Message < ApplicationRecord
  belongs_to :connection
  belongs_to :sender, polymorphic: true
end
