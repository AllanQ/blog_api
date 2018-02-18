class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,     null: false
      t.string  :ip_address,  null: false, limit: 45
      t.string  :title,       null: false
      t.text    :content,     null: false
      t.integer :rating,      limit: 2, index: true
      t.integer :rates_count, default: 0
      t.integer :rates_sum,   default: 0

      t.timestamps
    end
  end
end
