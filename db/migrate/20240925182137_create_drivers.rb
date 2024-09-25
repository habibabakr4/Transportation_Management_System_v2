class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.string :email
      t.string :

      t.timestamps
    end
  end
end
