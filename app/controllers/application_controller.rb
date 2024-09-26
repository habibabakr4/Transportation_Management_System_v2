class ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :authenticate_driver

  private

  def authenticate_driver
    Rails.logger.debug "Authenticating driver"
    
    # Extract the token from the Authorization header
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.debug "Token extracted: #{token}"
    
    # Decode the token if present
    if token
      @current_driver = JwtService.decode(token)
      Rails.logger.debug "Decoded token: #{@current_driver}"
    end
    
    # If driver is not authenticated, return unauthorized response
    unless @current_driver
      Rails.logger.warn "Unauthorized access attempt"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
