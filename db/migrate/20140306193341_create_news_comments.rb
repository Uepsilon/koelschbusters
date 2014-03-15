class CreateNewsComments < ActiveRecord::Migration
  def change
    create_table :news_comments do |t|

      t.string      :username
      t.text        :body
      t.references  :news
      t.references  :user

      t.string      :token

      t.timestamps
    end

    add_index :news_comments, :token, unique: true
  end
end
