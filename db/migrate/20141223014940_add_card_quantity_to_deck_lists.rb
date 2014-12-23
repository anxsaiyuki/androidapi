class AddCardQuantityToDeckLists < ActiveRecord::Migration
  def change
    add_column :deck_lists, :card_quantity, :integer
  end
end
