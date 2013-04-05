class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.text :teaser
      t.references :user

      t.timestamps
    end

    add_index :news, :slug, :unique => true
  end
end
