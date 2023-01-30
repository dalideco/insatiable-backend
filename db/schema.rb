# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_29_181003) do
  create_table "offers", force: :cascade do |t|
    t.integer "minimum_bid", null: false
    t.integer "current_bid"
    t.integer "buy_now_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.integer "weapon_id"
  end

  create_table "own_packs", force: :cascade do |t|
    t.integer "player_id"
    t.integer "pack_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owns", force: :cascade do |t|
    t.integer "player_id"
    t.integer "weapon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packs", force: :cascade do |t|
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "avatar"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_players_on_email", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "image"
    t.string "stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "variant", default: 0
  end

end
