class RemoveShareUserIdToDeckNames < ActiveRecord::Migration
  def change
    remove_column :deck_names, :share_user_id, :integer
  end
end