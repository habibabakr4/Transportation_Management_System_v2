class ApplicationController < ActionController::API
    include Pagy::Backend
    before_action :authenticate_request
  
    private
  
    # Authenticates the incoming request using the Authorization header
    def authenticate_request
      token = request.headers['Authorization']&.split(' ')&.last
      if token.present?
        begin
          decoded_token = JwtService.decode(token)
          @current_driver = Driver.find(decoded_token[:driver_id])
        rescue JWT::DecodeError, JWT::ExpiredSignature
          render json: { error: 'Unauthorized or Invalid token' }, status: :unauthorized
        end
      else
        render json: { error: 'Token missing' }, status: :unauthorized
      end
    end
end
  