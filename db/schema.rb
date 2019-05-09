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

ActiveRecord::Schema.define(version: 2019_05_09_025133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buttcoins", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "amount"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_buttcoins_on_user_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "hole_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hole_id"], name: "index_chat_messages_on_hole_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
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

  create_table "grab_tips", force: :cascade do |t|
    t.bigint "grab_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount"
    t.index ["grab_id"], name: "index_grab_tips_on_grab_id"
    t.index ["user_id"], name: "index_grab_tips_on_user_id"
  end

  create_table "grabs", force: :cascade do |t|
    t.string "image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.text "description"
    t.integer "media_type", default: 0
    t.bigint "hole_id"
    t.jsonb "accelerator_metadata"
    t.index ["hole_id"], name: "index_grabs_on_hole_id"
    t.index ["user_id"], name: "index_grabs_on_user_id"
  end

  create_table "hole_memberships", force: :cascade do |t|
    t.bigint "hole_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hole_id"], name: "index_hole_memberships_on_hole_id"
    t.index ["user_id"], name: "index_hole_memberships_on_user_id"
  end

  create_table "holes", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "chomments_enabled", default: false
    t.boolean "web_upload_enabled", default: false
    t.boolean "private_grabs_enabled", default: false
    t.boolean "chat_enabled", default: false
  end

  create_table "invites", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "invited_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hole_id"
    t.index ["code"], name: "index_invites_on_code", unique: true
    t.index ["hole_id"], name: "index_invites_on_hole_id"
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "memos", force: :cascade do |t|
    t.integer "variant", default: 0
    t.string "media_path"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "grab_id"
    t.boolean "pending", default: true
    t.integer "calling_code"
    t.string "call_sid"
    t.text "meta"
    t.index ["call_sid"], name: "index_memos_on_call_sid", unique: true
    t.index ["calling_code"], name: "index_memos_on_calling_code", unique: true
    t.index ["grab_id"], name: "index_memos_on_grab_id"
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
    t.index ["created_at"], name: "index_notes_on_created_at"
    t.index ["cross_ref_type", "cross_ref_id"], name: "index_notes_on_cross_ref_type_and_cross_ref_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
    t.index ["variant"], name: "index_notes_on_variant"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "name"
    t.string "bio"
    t.text "blocked", default: [], array: true
    t.datetime "sup_last_requested_at"
    t.integer "grabs_count"
    t.boolean "is_contributor"
    t.boolean "is_staff"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "buttcoins", "users"
  add_foreign_key "chat_messages", "holes"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "grab_tips", "grabs"
  add_foreign_key "grab_tips", "users"
  add_foreign_key "grabs", "holes"
  add_foreign_key "hole_memberships", "holes"
  add_foreign_key "hole_memberships", "users"
  add_foreign_key "invites", "holes"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", column: "actor_id"
end
