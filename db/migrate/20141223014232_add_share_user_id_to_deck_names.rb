class AddShareUserIdToDeckNames < ActiveRecord::Migration
  def change
    add_column :deck_names, :share_user_id, :integer
  end
end