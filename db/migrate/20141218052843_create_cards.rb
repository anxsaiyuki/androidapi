class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_id
      t.string :card_name
      t.string :card_type
      t.string :color
      t.string :g_sign
      t.integer :total_cost
      t.integer :roll_cost
      t.integer :atk_power
      t.integer :sup_power
      t.integer :def_power
      t.string :area
      t.string :special_description
      t.string :description
      t.string :effect
      t.string :pack_name
      t.string :rarity
      t.string :serial
      t.string :artist
      t.string :img_name

      t.timestamps
    end
  end
end
