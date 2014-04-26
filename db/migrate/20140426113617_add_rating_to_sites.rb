class AddRatingToSites < ActiveRecord::Migration
  def change
    add_column :sites, :rating, :integer
  end
end
