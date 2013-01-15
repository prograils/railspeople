class AddSettingsColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :looking_for_work, :integer, :default => 0
    add_column :users, :search_visibility, :boolean, :default => true
    add_column :users, :email_privacy, :integer, :default => 1
    add_column :users, :im_privacy, :boolean, :default => false
  end
end
