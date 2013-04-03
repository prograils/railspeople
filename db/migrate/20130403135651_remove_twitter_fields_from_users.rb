class RemoveTwitterFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :twitter_id
    remove_column :users, :twitter_screen_name
    remove_column :users, :twitter_display_name
  end
end
