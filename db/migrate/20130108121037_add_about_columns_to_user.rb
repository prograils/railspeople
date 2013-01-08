class AddAboutColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text
    add_column :users, :blog_url, :string
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :google_plus, :string
    add_column :users, :github, :string
    add_column :users, :stackoverflow, :string
  end
end
