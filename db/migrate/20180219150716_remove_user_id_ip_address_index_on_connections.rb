class RemoveUserIdIpAddressIndexOnConnections < ActiveRecord::Migration[5.1]
  def change
    remove_index :connections, %i[user_id ip_address]
  end
end
