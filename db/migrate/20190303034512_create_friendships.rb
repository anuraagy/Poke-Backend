class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.belongs_to :user,   null: false
      t.belongs_to :friend, null: false
      t.timestamps
    end
  end
end
