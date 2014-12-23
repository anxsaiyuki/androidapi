class CreateDeckNames < ActiveRecord::Migration
  def change
    create_table :deck_names do |t|
      t.integer :user_id
      t.string :Deck_Name
      t.integer :status

      t.timestamps
    end
  end
end
