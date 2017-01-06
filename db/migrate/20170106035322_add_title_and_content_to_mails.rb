class AddTitleAndContentToMails < ActiveRecord::Migration[5.0]
  def change
    add_column :mails, :title, :string
    add_column :mails, :content, :text
  end
end
