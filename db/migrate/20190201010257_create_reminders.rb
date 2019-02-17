class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.string  :title,       null: false
      t.string  :description, null: false
      t.string  :status,      null: false, default: "new"
      t.boolean :public,      null: false, default: true

      t.references :creator, null: false
      t.references :caller

      t.datetime :will_trigger_at, null: false
      t.datetime :triggered_at

      t.timestamps
    end

    add_foreign_key :reminders, :users, column: :creator_id, primary_key: :id
    add_foreign_key :reminders, :users, column: :caller_id,  primary_key: :id
  end
end
