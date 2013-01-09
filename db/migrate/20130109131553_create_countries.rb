class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries do |t|
      t.string :name
      t.string :printable_name
      t.string :iso
      t.string :iso3
      t.string :numcode
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def down
    drop_table :countries
  end
end
