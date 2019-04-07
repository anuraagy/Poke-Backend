class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :content,      null: false
      t.belongs_to :user,     null: false, index: true
      t.belongs_to :reminder, null: false, index: true
      t.timestamps
    end
  end
end
