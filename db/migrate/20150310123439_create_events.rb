class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.boolean :internal, default: true
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :location, null: false

      t.timestamps
    end
  end
end
