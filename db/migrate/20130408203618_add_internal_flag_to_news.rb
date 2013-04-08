class AddInternalFlagToNews < ActiveRecord::Migration
  def change
    add_column :news, :internal, :boolean, :default => :false
    add_index :news, :internal
  end
end
