class AddsNotifactionToNews < ActiveRecord::Migration
  def up
    add_column :news, :notified_at, :time
  end

  def down
    remove_column :news, :notified_at
  end
end
