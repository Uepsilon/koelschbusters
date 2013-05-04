class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.boolean :internal
      t.references :gallery

      t.timestamps
    end

    add_index :pictures, :internal
    add_attachment :pictures, :picture
  end
end
