# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :authenticate_driver

  private

  def authenticate_driver
    token = request.headers['Authorization']&.split(' ')&.last
  
    if token
      decoded_token = JwtService.decode(token)
      @current_driver = Driver.find_by(id: decoded_token['driver_id']) if decoded_token
    end
  
    return if @current_driver
  
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
  
end
