class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_ancestry

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pairs
  belongs_to :role, optional: true


  has_one :sponser, class_name: 'User', foreign_key: :sponsered_by_id
  belongs_to :sponser, class_name: 'User', foreign_key: :sponsered_by_id, optional: :true

  validates :name, presence: true
  validates :sponser_id, presence: true
  validates :position, presence: true
  validates :phone_number, numericality: { only_integer: true }, length: { minimum: 10 }
  validates :zipcode, numericality: { only_integer: true }, length: { minimum: 6 }
  validates :pan_number, presence: true, uniqueness: true, length: { minimum: 10 }



    def admin?
        role.role_type.eql?('admin')
    end
end
