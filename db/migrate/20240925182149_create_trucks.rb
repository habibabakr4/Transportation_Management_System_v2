class CreateTrucks < ActiveRecord::Migration[7.0]
  def change
    create_table :trucks do |t|
      t.string :name
      t.string :truck_type

      t.timestamps
    end
  end
end
