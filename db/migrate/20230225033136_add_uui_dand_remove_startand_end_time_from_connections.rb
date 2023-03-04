class AddUuiDandRemoveStartandEndTimeFromConnections < ActiveRecord::Migration[7.0]
  def change
    remove_column :connections, :start_time
    remove_column :connections, :end_time
    add_column :connections, :uuid, :string
  end
end
