class RenameNewsCommentsToComments < ActiveRecord::Migration
  def change
    rename_table :news_comments, :comments
  end
end
