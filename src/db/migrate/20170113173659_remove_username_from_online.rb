class RemoveUsernameFromOnline < ActiveRecord::Migration[5.0]
  def change
    remove_column :onlines, :username
  end
end
