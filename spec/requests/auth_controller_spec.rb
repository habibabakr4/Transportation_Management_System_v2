# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AuthController', type: :request do
  let(:valid_attributes) do
    {
      email: 'driver@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  let(:invalid_attributes) do
    { email: 'driver@example.com', password: 'password', password_confirmation: 'wrong_password' }
  end

  describe 'POST /signup' do
    context 'with valid parameters' do
      it 'creates a new Driver' do
        expect do
          post '/signup', params: { driver: valid_attributes }
        end.to change(Driver, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Driver created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        expect do
          post '/signup', params: { driver: invalid_attributes }
        end.to_not change(Driver, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe 'POST /login' do
    let!(:driver) { create(:driver) } # Create a driver before the test runs
    let(:valid_credentials) do
      {
        email: driver.email,
        password: driver.password
      }
    end

    it 'authenticates the driver and returns a token' do
      # First, create a token for the driver manually (or adjust based on your logic)
      # For example, if you have a method to generate a token, you can do that here
      token = JWT.encode({ driver_id: driver.id }, Rails.application.secrets.secret_key_base)

      # Now send the login request with the Authorization header
      post '/login', params: valid_credentials, headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Authorized successfully')
    end
  end
end
