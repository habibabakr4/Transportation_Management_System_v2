class TrucksController < ApplicationController
  before_action :authenticate_driver

  def index
    if @current_driver.nil?
      Rails.logger.error("Current driver not found.")
      render json: { error: 'Unauthorized' }, status: :unauthorized and return
    end

    Rails.logger.info("Fetching all trucks for driver: #{@current_driver.id}")
    @trucks = Truck.all
    Rails.logger.info("Found #{@trucks.count} trucks")
    render json: @trucks
  end

  def create
    truck = Truck.new(truck_params)

    if truck.save
      Rails.logger.info("Truck created successfully: #{truck.id}")
      render json: { message: 'Truck created successfully', truck: truck }, status: :created
    else
      Rails.logger.error("Failed to create truck: #{truck.errors.full_messages.join(", ")}")
      render json: { error: 'Truck creation failed', errors: truck.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def assign
    if @current_driver.nil?
      Rails.logger.error("Current driver not found.")
      render json: { error: 'Unauthorized' }, status: :unauthorized and return
    end
  
    Rails.logger.info("Assigning truck #{params[:truck_id]} to driver #{@current_driver.id}")
    truck = Truck.find_by(id: params[:truck_id])
  
    if truck
      assignment = Assignment.new(driver: @current_driver, truck: truck, assigned_at: Time.now)
      if assignment.save
        Rails.logger.info("Truck #{truck.id} assigned to driver #{@current_driver.id}")
        render json: { message: 'Truck assigned' }, status: :ok
      else
        Rails.logger.error("Failed to assign truck: #{assignment.errors.full_messages.join(", ")}")
        render json: { error: 'Assignment failed', errors: assignment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      Rails.logger.error("Truck not found: #{params[:truck_id]}")
      render json: { error: 'Truck not found' }, status: :not_found
    end
  end
  

  def my_trucks
    if @current_driver.nil?
      Rails.logger.error("Current driver not found.")
      render json: { error: 'Unauthorized' }, status: :unauthorized and return
    end

    Rails.logger.info("Fetching trucks for driver: #{@current_driver.id}")
    @trucks = @current_driver.trucks
    Rails.logger.info("Driver #{@current_driver.id} has #{@trucks.count} trucks")
    render json: @trucks
  end

  private

  def truck_params
    params.require(:truck).permit(:name, :truck_type) # Adjust attributes as needed
  end
end
