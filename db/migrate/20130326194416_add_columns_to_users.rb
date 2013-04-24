class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid,     :string
    add_column :users, :twitter_name,    :string

    add_column :users, :facebook_uid,    :string
    add_column :users, :facebook_name,   :string

    add_column :users, :google_uid,      :string
    add_column :users, :google_name,     :string

    add_index :users, :twitter_uid,   :unique => true
    add_index :users, :facebook_uid,  :unique => true
    add_index :users, :google_uid,    :unique => true
  end
end
