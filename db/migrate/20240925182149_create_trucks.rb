# frozen_string_literal: true

class CreateTrucks < ActiveRecord::Migration[7.0]
  def change
    create_table :trucks do |t|
      t.string :name, null: false
      t.string :truck_type, null: false

      t.timestamps
    end
  end
end
