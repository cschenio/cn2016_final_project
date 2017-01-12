class AddOnlineFile < ActiveRecord::Migration[5.0]
  def change
    create_table :online_files do |t|
      t.string :from
      t.string :to
      t.string :filename
    end
  end
end
