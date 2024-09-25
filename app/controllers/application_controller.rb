class ApplicationController < ActionController::API
    before_action :authenticate_request

    private
  
    def authenticate_request
      token = request.headers['Authorization']&.split(' ')&.last
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      @current_driver = Driver.find(decoded_token['driver_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
    
    def encode_token(driver_id)
        JWT.encode({ driver_id: driver_id, exp: 24.hours.from_now.to_i }, Rails.application.secrets.secret_key_base)
    end
end
