class CreateSymptoms < ActiveRecord::Migration[7.0]
  def change
    create_table :symptoms do |t|
      t.string :location
      t.string :symptom_en
      t.string :symptom_jp

      t.timestamps
    end
  end
end
