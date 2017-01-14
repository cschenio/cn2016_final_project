class CreateMails < ActiveRecord::Migration[5.0]
  def change
    create_table :mails
    add_reference :mails, :user, foreign_key: true
    add_reference :mails, :mailbox, foreign_key: true
  end
end
