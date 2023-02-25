class AddCallStatusToConnections < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :call_status, :string
  end
end
