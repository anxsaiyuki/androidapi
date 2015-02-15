class CreateDeckCommentPriorities < ActiveRecord::Migration
  def change
    create_table :deck_comment_priorities do |t|
      t.integer :user_id
      t.integer :deck_comment_id

      t.timestamps
    end
  end
end
