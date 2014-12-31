class CreatePackNames < ActiveRecord::Migration
  def change
    create_table :pack_names do |t|
      t.string :pack_name

      t.timestamps
    end
  end
end
