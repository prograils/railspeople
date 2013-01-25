class AddAdditionalServicesToUser < ActiveRecord::Migration
  def up
    add_column :users, :flickr, :string
    add_column :users, :delicious, :string
    add_column :users, :linkedin, :string
    add_column :users, :bitbucket, :string
    add_column :users, :gtalk, :string
    add_column :users, :skype, :string
    add_column :users, :jabber, :string
  end

  def down
    remove_column :users, :flickr
    remove_column :users, :delicious
    remove_column :users, :linkedin
    remove_column :users, :bitbucket
    remove_column :users, :gtalk
    remove_column :users, :skype
    remove_column :users, :jabber
  end
end
