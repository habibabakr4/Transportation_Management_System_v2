class AuthController < ApplicationController
  def signup
    driver = Driver.new(driver_params)
    if driver.save
      render json: { message: 'Driver created successfully' }, status: :created
    else
      render json: { errors: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    driver = Driver.find_by(email: params[:email])
    if driver && driver.authenticate(params[:password])
      token = JwtService.encode(driver_id: driver.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def driver_params
    params.require(:driver).permit(:email, :password, :password_confirmation)
  end
end
