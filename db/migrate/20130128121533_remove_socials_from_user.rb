class RemoveSocialsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :twitter
    remove_column :users, :facebook
    remove_column :users, :google_plus
    remove_column :users, :github
    remove_column :users, :stackoverflow
    remove_column :users, :flickr
    remove_column :users, :delicious
    remove_column :users, :linkedin
    remove_column :users, :bitbucket
  end

  def down
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :google_plus, :string
    add_column :users, :github, :string
    add_column :users, :stackoverflow, :string
    add_column :users, :flickr, :string
    add_column :users, :delicious, :string
    add_column :users, :linkedin, :string
    add_column :users, :bitbucket, :string

  end
end
