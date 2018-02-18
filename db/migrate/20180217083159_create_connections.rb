class CreateConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :connections, id: false do |t|
      t.string  :ip_address, null: false, limit: 45
      t.integer :user_id,    null: false
    end

    add_index :connections, %i[ip_address user_id], unique: true
    add_index :connections, %i[user_id ip_address]
  end
end
