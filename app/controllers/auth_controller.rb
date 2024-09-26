# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate_driver, only: [:signup]

  def signup
    driver = Driver.new(driver_params)

    if driver.save
      token = JwtService.encode(driver_id: driver.id)
      render json: { token:, message: 'Driver created successfully' }, status: :created
    else
      render json: { errors: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    Rails.logger.debug "Login process started with params: #{params.inspect}"

    driver = Driver.find_by(email: params[:email])

    if driver&.authenticate(params[:password])

      render json: { message: 'Authorized successfully' }, status: :ok
    else

      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def driver_params
    params.require(:driver).permit(:email, :password, :password_confirmation)
  end
end
