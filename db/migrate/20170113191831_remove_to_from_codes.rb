class RemoveToFromCodes < ActiveRecord::Migration[5.0]
  def change
    remove_column :codes, :mailbox
  end
end
