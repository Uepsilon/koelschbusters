class RemoveSlugFromNews < ActiveRecord::Migration
  def change
    remove_column :news, :slug

  end
end
