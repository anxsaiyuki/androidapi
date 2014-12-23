class CreateDeckLists < ActiveRecord::Migration
  def change
    create_table :deck_lists do |t|
      t.integer :user_id
      t.integer :card_id
      t.string :deck_name
      t.integer :status

      t.timestamps
    end
  end
end
