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

ActiveRecord::Schema.define(version: 20171220210418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buttcoin_ledgers", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "amount"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_buttcoin_ledgers_on_user_id"
  end

  create_table "chomments", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "variant", default: 0
    t.string "cross_ref_type"
    t.bigint "cross_ref_id"
    t.index ["cross_ref_type", "cross_ref_id"], name: "index_chomments_on_cross_ref_type_and_cross_ref_id"
    t.index ["user_id"], name: "index_chomments_on_user_id"
  end

  create_table "memos", force: :cascade do |t|
    t.integer "variant", default: 0
    t.string "media_path"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "shot_id"
    t.boolean "pending", default: true
    t.integer "calling_code"
    t.string "call_sid"
    t.index ["call_sid"], name: "index_memos_on_call_sid", unique: true
    t.index ["calling_code"], name: "index_memos_on_calling_code", unique: true
    t.index ["shot_id"], name: "index_memos_on_shot_id"
    t.index ["user_id"], name: "index_memos_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "actor_id"
    t.string "cross_ref_type"
    t.bigint "cross_ref_id"
    t.string "variant"
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notes_on_actor_id"
    t.index ["cross_ref_type", "cross_ref_id"], name: "index_notes_on_cross_ref_type_and_cross_ref_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
    t.index ["variant"], name: "index_notes_on_variant"
  end

  create_table "shots", force: :cascade do |t|
    t.string "image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_shots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "name"
    t.string "bio"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "buttcoin_ledgers", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", column: "actor_id"
end
