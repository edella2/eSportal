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

ActiveRecord::Schema.define(version: 20160114193744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "country_name"
    t.string   "country_short_name"
    t.string   "country_image_default"
    t.string   "country_image_thumbnail"
    t.string   "race"
  end

  create_table "competitors_tournaments", force: :cascade do |t|
    t.integer "competitor_id"
    t.integer "tournament_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "favoritable_id"
    t.integer  "user_id"
    t.string   "favoritable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "long_title"
    t.string   "image_square"
    t.string   "image_circle"
    t.string   "image_rectangle"
  end

  create_table "streams", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "tournament_id"
    t.string   "language"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "title"
    t.datetime "start"
    t.datetime "end"
    t.string   "image_thumbnail"
    t.string   "image_large"
    t.string   "description"
    t.string   "short_description"
    t.string   "city"
    t.string   "short_title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "image_default"
    t.string   "prizepool_total"
    t.string   "prizepool_first"
    t.string   "prizepool_second"
    t.string   "prizepool_third"
    t.string   "link_website"
    t.string   "link_wiki"
    t.string   "link_youtube"
    t.string   "url"
    t.integer  "game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "token"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
