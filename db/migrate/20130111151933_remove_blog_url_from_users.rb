class RemoveBlogUrlFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :blog_url
  end
end
