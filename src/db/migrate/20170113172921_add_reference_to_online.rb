class AddReferenceToOnline < ActiveRecord::Migration[5.0]
  def change
    add_reference :onlines, :user, foreign_key: true
  end
end
