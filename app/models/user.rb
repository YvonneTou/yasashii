class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :connections
  has_many :messages, as: :sender
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
