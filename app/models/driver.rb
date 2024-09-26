# frozen_string_literal: true

class Driver < ApplicationRecord
  has_secure_password
  has_many :assignments
  has_many :trucks, through: :assignments

  validates :email, presence: true, uniqueness: true

  after_create :log_driver_creation

  private

  def log_driver_creation
    Rails.logger.info("Driver created with ID: #{id}")
  end
end
