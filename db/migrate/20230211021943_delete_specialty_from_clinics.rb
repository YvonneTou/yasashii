class DeleteSpecialtyFromClinics < ActiveRecord::Migration[7.0]
  def change
    remove_column :clinics, :specialty
  end
end
