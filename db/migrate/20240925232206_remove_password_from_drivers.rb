class RemovePasswordFromDrivers < ActiveRecord::Migration[7.0]
  def change
    remove_column :drivers, :password, :string
  end
end
