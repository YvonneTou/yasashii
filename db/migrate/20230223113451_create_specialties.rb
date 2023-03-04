class CreateSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :specialties do |t|
      t.references :symptom, null: false, foreign_key: true
      t.references :clinic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
