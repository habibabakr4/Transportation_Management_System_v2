class Driver < ApplicationRecord
    has_secure_password
    has_many :assignments
    has_many :trucks, through: :assignments
  
    validates :email, presence: true, uniqueness: true
end
