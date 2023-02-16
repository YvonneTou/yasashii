class EditSymptomsInConnections < ActiveRecord::Migration[7.0]
  def change
    remove_column :connections, :symptoms
    add_column :connections, :symptoms, :text, array: true, default: []
  end
end
