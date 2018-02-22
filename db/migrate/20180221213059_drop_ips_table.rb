class DropIpsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :ips, id: false do |t|
      t.string  :address,     null: false, limit: 45, primary_key: true
      t.integer :users_count, null: false, default: 1, index: true
    end
  end
end
