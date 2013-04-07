class AddPublishedToNews < ActiveRecord::Migration
  def change
    add_column :news, :published_at, :datetime
    add_index :news, :published_at
  end
end
