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

ActiveRecord::Schema.define(version: 20150913172838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "talk_id"
    t.string   "comment"
    t.string   "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["talk_id"], name: "index_comments_on_talk_id", using: :btree

  create_table "configurations", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "place"
    t.string   "description"
    t.string   "cfp_description"
    t.date     "start_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "talk_id"
    t.integer  "vote"
    t.string   "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ratings", ["talk_id"], name: "index_ratings_on_talk_id", using: :btree

  create_table "suggestions", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "speaker"
    t.string   "format"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "event_id"
    t.string   "track"
  end

  create_table "talks", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "title"
    t.string   "description"
    t.string   "speaker"
    t.string   "format"
    t.time     "time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "track"
  end

  add_index "talks", ["event_id"], name: "index_talks_on_event_id", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
