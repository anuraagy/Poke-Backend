class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :reason, null: false

      t.belongs_to :reporter, null: false
      t.belongs_to :reportee, null: false
      t.timestamps
    end
  end
end
