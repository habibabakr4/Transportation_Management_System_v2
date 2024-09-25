json.trucks @trucks do |truck|
    json.id truck.id
    json.name truck.name
    json.truck_type truck.truck_type
  end
  
  json.meta do
    json.current_page @pagy.page
    json.next_page @pagy.next
    json.prev_page @pagy.prev
    json.items @pagy.count
    json.total_pages @pagy.pages
  end
  