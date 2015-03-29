class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.boolean :participation, null: false, default: false

      t.timestamps null: false
    end

    add_index :user_events, [:user_id, :event_id], unique: true
  end
end
