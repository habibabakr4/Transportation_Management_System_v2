class FetchTrucksWorker
    include Sidekiq::Worker
  
    def perform
      current_page = 1
      loop do
        response = fetch_trucks(current_page)
        break if response.empty?
  
        response.each do |truck_data|
          Truck.create_with(truck_type: truck_data['truck_type']).find_or_create_by(name: truck_data['name'])
        end
  
        current_page += 1
      end
    end
  
    private
  
    def fetch_trucks(page)
      headers = { 'API_KEY': 'illa-trucks-2023' }
      response = HTTParty.get("https://api-task-bfrm.onrender.com/api/v1/trucks?page=#{page}", headers: headers)
      response.parsed_response
    end
  end
  