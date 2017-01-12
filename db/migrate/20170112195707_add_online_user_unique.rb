class AddOnlineUserUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :onlines, :username, unique: true
  end
end
