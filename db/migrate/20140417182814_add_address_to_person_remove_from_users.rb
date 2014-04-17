class AddAddressToPersonRemoveFromUsers < ActiveRecord::Migration
  def change
    add_column :people, :lat, :float
    add_column :people, :lon, :float
    add_column :people, :gmaps, :boolean
    add_column :people, :street_number, :integer
    add_column :people, :street_name, :string
    add_column :people, :street, :string
    add_column :people, :city, :string
    add_column :people, :zipcode, :string
    add_column :people, :latitude, :string
    add_column :people, :longitude, :string

    remove_column :users, :lat
    remove_column :users, :lon
    remove_column :users, :gmaps
    remove_column :users, :street_number
    remove_column :users, :street_name
    remove_column :users, :street
    remove_column :users, :city
    remove_column :users, :zipcode
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
