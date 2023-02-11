class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :connections, dependent: :destroy
  has_many :messages, as: :sender
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
