class AddPrimaryKeyOnConnection < ActiveRecord::Migration[5.1]
  def up
    execute "ALTER TABLE connections ADD PRIMARY KEY (user_id, ip_address);"
  end

  def down
    execute "ALTER TABLE connections DROP CONSTRAINT connections_pkey"
  end
end
