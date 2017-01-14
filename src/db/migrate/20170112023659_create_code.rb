class CreateCode < ActiveRecord::Migration[5.0]
  def change
    create_table :codes
    add_reference :codes, :user, foreign_key: true
    add_reference :codes, :mailbox, foreign_key: true
    add_column :codes, :lang, :string
    add_column :codes, :content, :text
  end
end
