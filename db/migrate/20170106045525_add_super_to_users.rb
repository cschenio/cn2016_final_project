class AddSuperToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :super, :boolean
  end
end
