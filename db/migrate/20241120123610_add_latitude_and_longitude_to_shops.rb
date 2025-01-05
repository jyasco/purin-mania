class AddLatitudeAndLongitudeToShops < ActiveRecord::Migration[7.2]
  def change
    add_column :shops, :latitude, :float
    add_column :shops, :longitude, :float

    reversible do |dir|
      dir.up do
        Shop.find_each do |shop|
          shop.geocode
          shop.save
        end
      end
    end
  end
end
