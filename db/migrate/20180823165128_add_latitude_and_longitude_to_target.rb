class AddLatitudeAndLongitudeToTarget < ActiveRecord::Migration[5.2]
  def change
  	add_column :targets, :latitude,  :float, null: false
  	add_column :targets, :longitude, :float, null: false
  end
end
