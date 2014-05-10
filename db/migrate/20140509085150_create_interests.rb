class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :name

      t.timestamps
    end

    create_table :person_interests do |t|
      t.belongs_to :person
      t.belongs_to :interest
    end
  end
end
