class AddFileAlert < ActiveRecord::Migration[5.0]
  def change
    add_column :onlines, :has_file, :boolean
  end
end
