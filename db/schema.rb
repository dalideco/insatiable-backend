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

ActiveRecord::Schema[7.0].define(version: 2023_04_29_204845) do
  create_table "offers", force: :cascade do |t|
    t.integer "minimum_bid", null: false
    t.integer "current_bid"
    t.integer "buy_now_price", null: false
    t.datetime "created_at", default: "2023-04-30 16:50:25", null: false
    t.datetime "updated_at", default: "2023-04-30 16:50:25", null: false
    t.integer "player_id"
    t.integer "weapon_id"
    t.integer "status", default: 0
    t.integer "lifetime", default: 0
    t.integer "latest_bidder_id"
  end

  create_table "own_packs", force: :cascade do |t|
    t.integer "player_id"
    t.integer "pack_id"
    t.datetime "created_at", default: "2023-04-30 16:50:25", null: false
    t.datetime "updated_at", default: "2023-04-30 16:50:25", null: false
  end

  create_table "owns", force: :cascade do |t|
    t.integer "player_id"
    t.integer "weapon_id"
    t.datetime "created_at", default: "2023-04-30 16:50:25", null: false
    t.datetime "updated_at", default: "2023-04-30 16:50:25", null: false
  end

  create_table "packs", force: :cascade do |t|
    t.integer "price", null: false
    t.datetime "created_at", default: "2023-04-30 16:50:25", null: false
    t.datetime "updated_at", default: "2023-04-30 16:50:25", null: false
    t.string "title", default: "Pack"
    t.integer "chance_common_weapon", default: 0
    t.integer "chance_rare_weapon", default: 0
    t.integer "chance_very_rare_weapon", default: 0
    t.integer "chance_epic_weapon", default: 0
    t.integer "chance_legendary_weapon", default: 0
  end

  create_table "players", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "avatar"
    t.datetime "confirmed_at"
    t.datetime "created_at", default: "2023-04-30 16:50:25", null: false
    t.datetime "updated_at", default: "2023-04-30 16:50:25", null: false
    t.integer "coins", default: 1000
    t.index ["email"], name: "index_players_on_email", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "image"
    t.string "stats"
    t.datetime "created_at", default: "2023-04-30 16:50:25", null: false
    t.datetime "updated_at", default: "2023-04-30 16:50:25", null: false
    t.integer "variant", default: 0
  end

end
