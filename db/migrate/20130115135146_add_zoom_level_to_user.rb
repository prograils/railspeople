class AddZoomLevelToUser < ActiveRecord::Migration
  def up
    add_column :users, :zoom, :integer
  end

  def down
    remove_column :users, :zoom
  end
end
