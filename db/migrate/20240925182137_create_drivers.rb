class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.string :email, null: false, unique: true
      t.string :password, null: false
      
      t.timestamps
    end
  end
end
