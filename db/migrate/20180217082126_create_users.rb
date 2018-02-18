class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login, null: false, limit: 80, index: true

      t.timestamps
    end
  end
end
