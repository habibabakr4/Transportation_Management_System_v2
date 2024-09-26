# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TrucksController', type: :request do
  let(:driver) { Driver.create(email: 'driver@example.com', password: 'password', password_confirmation: 'password') }
  let!(:truck1) { Truck.create(name: 'Truck 1', truck_type: 'Type A') }
  let!(:truck2) { Truck.create(name: 'Truck 2', truck_type: 'Type B') }

  let(:valid_headers) do
    token = JwtService.encode(driver_id: driver.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /index' do
    context 'when authenticated' do
      it 'returns a list of trucks' do
        get '/trucks', headers: valid_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match_array([truck1, truck2].as_json)
      end
    end

    context 'when not authenticated' do
      it 'returns an unauthorized status' do
        get '/trucks'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /assign' do
    context 'when authenticated' do
      it 'assigns a truck to the driver' do
        expect do
          post '/trucks/assign', params: { truck_id: truck1.id }, headers: valid_headers
        end.to change(Assignment, :count).by(1)

        expect(response).to have_http_status(:created)
        assignment = Assignment.last
        expect(assignment.driver_id).to eq(driver.id)
        expect(assignment.truck_id).to eq(truck1.id)
      end

      it 'returns an error if the assignment fails' do
        post '/trucks/assign', params: { truck_id: nil }, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end

    context 'when not authenticated' do
      it 'returns an unauthorized status' do
        post '/trucks/assign', params: { truck_id: truck1.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /my_trucks' do
    let!(:assignment1) { Assignment.create(driver:, truck: truck1, assigned_at: Time.now) }
    let!(:assignment2) { Assignment.create(driver:, truck: truck2, assigned_at: Time.now) }

    context 'when authenticated' do
      it 'returns a list of trucks assigned to the current driver' do
        get '/trucks/my_trucks', headers: valid_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match_array([truck1, truck2].as_json)
      end
    end

    context 'when not authenticated' do
      it 'returns an unauthorized status' do
        get '/trucks/my_trucks'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
