class CreateBlogs < ActiveRecord::Migration
  def up
    create_table :blogs do |t|
      t.integer :user_id, :null => false
      t.string :title, :default => ""
      t.string :url, :default => ""

      t.timestamps
    end
  end

  def down
    drop_table :blogs
  end
end
