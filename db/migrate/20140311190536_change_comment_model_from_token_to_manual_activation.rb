class ChangeCommentModelFromTokenToManualActivation < ActiveRecord::Migration
  def change
    remove_column :news_comments, :token

    add_column :news_comments, :activated_at, :datetime, default: nil
  end
end
