class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.belongs_to :user,     null: false, index: true
      t.belongs_to :reminder, null: false, index: true
      t.timestamps
    end
  end
end
