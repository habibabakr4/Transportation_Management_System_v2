class Assignment < ApplicationRecord
  belongs_to :driver
  belongs_to :truck

  validates :assigned_at, presence: true
end
