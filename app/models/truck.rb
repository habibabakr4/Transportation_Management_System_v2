class Truck < ApplicationRecord
    has_many :assignments
    has_many :drivers, through: :assignments
  
    validates :name, :truck_type, presence: true
end
