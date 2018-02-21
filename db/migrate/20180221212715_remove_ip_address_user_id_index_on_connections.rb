class RemoveIpAddressUserIdIndexOnConnections < ActiveRecord::Migration[5.1]
  def change
    remove_index :connections, %i[ip_address user_id]
  end
end
