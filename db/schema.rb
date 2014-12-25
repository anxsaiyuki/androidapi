# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141223163406) do

  create_table "cards", force: true do |t|
    t.string   "card_id"
    t.string   "card_name"
    t.string   "card_type"
    t.string   "color"
    t.string   "g_sign"
    t.integer  "total_cost"
    t.integer  "roll_cost"
    t.integer  "atk_power"
    t.integer  "sup_power"
    t.integer  "def_power"
    t.string   "area"
    t.string   "special_description"
    t.string   "description"
    t.string   "effect"
    t.string   "pack_name"
    t.string   "rarity"
    t.string   "serial"
    t.string   "artist"
    t.string   "img_name"
    t.string   "prodid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deck_lists", force: true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.string   "deck_name"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_quantity"
  end

  create_table "deck_names", force: true do |t|
    t.integer  "user_id"
    t.string   "Deck_Name"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "share_user_id"
  end

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
