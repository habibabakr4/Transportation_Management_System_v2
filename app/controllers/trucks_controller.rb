class TrucksController < ApplicationController
    before_action :authenticate_driver

  def index
    @trucks = Truck.all
    render json: @trucks
  end

  def assign
    assignment = Assignment.create(driver_id: @current_driver.id, truck_id: params[:truck_id], assignment_date: Time.now)
    if assignment.persisted?
      render json: assignment, status: :created
    else
      render json: { errors: assignment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def my_trucks
    @assignments = @current_driver.assignments.includes(:truck)
    render json: @assignments, include: :truck
  end
end
