class AddOnlineUser < ActiveRecord::Migration[5.0]
  def change
    create_table :onlines do |t|
      t.string :username
    end
  end
end
