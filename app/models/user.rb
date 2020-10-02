class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pairs
  validates :name, presence: true
  validates :sponser_id, presence: true
  validates :position, presence: true
  validates :pan_number, presence: true, uniqueness: true
end
