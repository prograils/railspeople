class AddGithubAndTwitter < ActiveRecord::Migration
  def up
    add_column :users, :github, :string
    add_column :users, :twitter, :string
  end

  def down
    remove_column :users, :github
    remove_column :users, :twitter
  end
end
