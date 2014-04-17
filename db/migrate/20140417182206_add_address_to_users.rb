class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lat, :float
    add_column :users, :lon, :float
    add_column :users, :gmaps, :boolean
    add_column :users, :street_number, :integer
    add_column :users, :street_name, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :zipcode, :string
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
  end
end
