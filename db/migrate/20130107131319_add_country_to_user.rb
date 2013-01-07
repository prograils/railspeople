class AddCountryToUser < ActiveRecord::Migration
  def up
    add_column :users, :country, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end

  def down
    remove_column :users, :country
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
