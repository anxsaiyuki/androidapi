class CreateDeckComments < ActiveRecord::Migration
  def change
    create_table :deck_comments do |t|
      t.integer :deck_id
      t.integer :user_id
      t.string :comment
      t.integer :priority

      t.timestamps
    end
  end
end
