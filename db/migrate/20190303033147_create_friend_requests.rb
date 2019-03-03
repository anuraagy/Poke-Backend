class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.belongs_to :sender,    null: false
      t.belongs_to :receiver,  null: false
      t.string     :status,    null: false, default: "sent"
      t.timestamps
    end
  end
end
