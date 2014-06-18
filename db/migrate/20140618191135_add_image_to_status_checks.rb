class AddImageToStatusChecks < ActiveRecord::Migration
  def change
    add_column :status_checks, :image, :string
  end
end
