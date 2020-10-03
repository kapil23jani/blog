class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_ancestry

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pairs


  has_one :sponser, class_name: 'User', foreign_key: :sponsered_by_id
  belongs_to :host, class_name: 'User', foreign_key: :sponsered_by_id

  validates :name, presence: true
  validates :sponser_id, presence: true
  validates :position, presence: true
  validates :pan_number, presence: true, uniqueness: true
end
