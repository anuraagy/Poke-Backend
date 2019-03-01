class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders, force: true do |t|
      t.string  :title,       null: false
      t.string  :description
      t.string  :status,      null: false, default: "new"
      t.string  :type
      t.boolean :public,      null: false, default: true
      t.boolean :push,        null: false, default: false

      t.references :creator, null: false
      t.references :caller

      t.datetime :will_trigger_at, null: false
      t.datetime :triggered_at

      t.integer :job_id


      t.timestamps
    end

    add_foreign_key :reminders, :users, column: :creator_id, primary_key: :id
    add_foreign_key :reminders, :users, column: :caller_id,  primary_key: :id
  end
end
