class CreateOAuthCredentials < ActiveRecord::Migration
  def change
    create_table :o_auth_credentials do |t|
      t.string :provider
      t.string :uid
      t.text :params
      t.references :user

      t.timestamps
    end
    add_index :o_auth_credentials, :user_id
  end
end
