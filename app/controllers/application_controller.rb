# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :authenticate_driver

  private

  def authenticate_driver
    token = request.headers['Authorization']&.split(' ')&.last

    @current_driver = JwtService.decode(token) if token

    return if @current_driver

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
