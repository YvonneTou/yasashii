class CreateClinics < ActiveRecord::Migration[7.0]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :specialty
      t.string :location
      t.string :hours
      t.string :phone_number
      t.string :email
      t.string :description

      t.timestamps
    end
  end
end
