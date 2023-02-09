class AddCallsToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :connection, foreign_key: true
    add_reference :messages, :sender, polymorphic: true, index: true
  end
end
