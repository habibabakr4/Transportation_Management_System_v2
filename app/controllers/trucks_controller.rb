# frozen_string_literal: true

class TrucksController < ApplicationController
  before_action :authenticate_driver

  def index
    Rails.logger.info("Fetching all trucks for driver: #{@current_driver.id}")
    @trucks = Truck.all
    Rails.logger.info("Found #{@trucks.count} trucks")
    render json: @trucks
  end

  def assign
    Rails.logger.info("Assigning truck #{params[:truck_id]} to driver #{@current_driver.id}")
    truck = Truck.find(params[:truck_id])

    if truck
      Assignment.create(driver: @current_driver, truck:)
      Rails.logger.info("Truck #{truck.id} assigned to driver #{@current_driver.id}")
      render json: { message: 'Truck assigned' }, status: :ok
    else
      Rails.logger.error("Truck not found: #{params[:truck_id]}")
      render json: { error: 'Truck not found' }, status: :not_found
    end
  end

  def my_trucks
    Rails.logger.info("Fetching trucks for driver: #{@current_driver.id}")
    @trucks = @current_driver.trucks
    Rails.logger.info("Driver #{@current_driver.id} has #{@trucks.count} trucks")
    render json: @trucks
  end
end
