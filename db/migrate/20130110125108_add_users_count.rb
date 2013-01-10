class AddUsersCount < ActiveRecord::Migration
  def up
    add_column :countries, :users_count, :integer, :default => 0
    
    Country.reset_column_information
    Country.all.each do |c|
      Country.update_counters c.id, :users_count => c.users.length
    end
  end

  def down
    remove_column :countries, :users_count
  end
end
