class CreateShareDecks < ActiveRecord::Migration
  def change
    create_table :share_decks do |t|
      t.integer :share_user_id
      t.belongs_to :deck_name

      t.timestamps
    end
  end
end
