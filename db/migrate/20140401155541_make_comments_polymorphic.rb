class MakeCommentsPolymorphic < ActiveRecord::Migration
  def up
    change_table :comments do |t|
      t.references :commentable, polymorphic: true
    end

    Comment.all.each do |comment|
      comment.commentable_id = comment.news_id
      comment.commentable_type = "News"
      comment.save!
    end

    remove_column :comments, :news_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
