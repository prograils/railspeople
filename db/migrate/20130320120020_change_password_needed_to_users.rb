class ChangePasswordNeededToUsers < ActiveRecord::Migration
  def change
    add_column :users, :change_password_needed, :boolean, :default => false
  end
end
