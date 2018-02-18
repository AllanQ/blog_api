# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180217083159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", id: false, force: :cascade do |t|
    t.string "ip_address", limit: 45, null: false
    t.integer "user_id", null: false
    t.index ["ip_address", "user_id"], name: "index_connections_on_ip_address_and_user_id", unique: true
    t.index ["user_id", "ip_address"], name: "index_connections_on_user_id_and_ip_address"
  end

  create_table "ips", primary_key: "address", id: :string, limit: 45, force: :cascade do |t|
    t.integer "users_count", default: 1, null: false
    t.index ["users_count"], name: "index_ips_on_users_count"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address", limit: 45, null: false
    t.string "title", null: false
    t.text "content", null: false
    t.integer "rating", limit: 2
    t.integer "rates_count", default: 0
    t.integer "rates_sum", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rating"], name: "index_posts_on_rating"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", limit: 80, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login"
  end

end