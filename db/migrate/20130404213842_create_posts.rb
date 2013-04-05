class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.text :teaser
      t.references :user

      t.timestamps
    end

    add_index :posts, :slug, :unique => true
  end
end
