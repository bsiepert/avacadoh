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

ActiveRecord::Schema.define(version: 20150916052027) do

  create_table "events", force: true do |t|
    t.integer  "pg_id"
    t.string   "name"
    t.string   "location"
    t.string   "description"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "round"
    t.integer  "event_id"
    t.integer  "p1_id"
    t.integer  "p2_id"
    t.integer  "p1_list_played"
    t.integer  "p2_list_played"
    t.integer  "p1_army_points"
    t.integer  "p2_army_points"
    t.integer  "p1_control_points"
    t.integer  "p2_control_points"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.integer "player_id"
    t.integer "event_id"
    t.boolean "active"
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id", using: :btree
  add_index "registrations", ["player_id"], name: "index_registrations_on_player_id", using: :btree

end
