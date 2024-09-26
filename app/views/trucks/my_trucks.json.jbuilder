# frozen_string_literal: true

json.assignments @assignments do |assignment|
  json.id assignment.id
  json.assignment_date assignment.assignment_date
  json.truck do
    json.id assignment.truck.id
    json.name assignment.truck.name
    json.make assignment.truck.make
    json.model assignment.truck.truck_type
  end
end
