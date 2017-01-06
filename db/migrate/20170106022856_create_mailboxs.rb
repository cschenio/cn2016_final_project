class CreateMailboxs < ActiveRecord::Migration[5.0]
  def change
    create_table :mailboxs
    add_reference :mailboxs, :user, foreign_key: true
  end
end
