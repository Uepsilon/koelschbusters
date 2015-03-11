class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.boolean :internal
      t.string :title
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :location

      t.timestamps
    end
  end
end
