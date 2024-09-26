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
    Rails.logger.debug "Driver found: #{driver.inspect}" if driver
  
    if driver && driver.authenticate(params[:password])
      Rails.logger.debug "Driver authenticated successfully."
  
      # You can still generate the token if you need it for future requests,
      # but here you will just return the success message.
      render json: { message: 'Authorized successfully' }, status: :ok
    else
      Rails.logger.debug "Invalid email or password. Driver: #{driver.inspect}"
  
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  

  private

  def driver_params
    params.require(:driver).permit(:email, :password, :password_confirmation)
  end
end
