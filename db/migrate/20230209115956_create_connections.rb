class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :clinic, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :appt_date
      t.integer :status, default: 0
      t.string :symptoms
      t.text :info
      t.timestamps
    end
  end
end
