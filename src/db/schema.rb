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

ActiveRecord::Schema.define(version: 20170113191831) do

  create_table "codes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mailbox_id"
    t.string  "lang"
    t.text    "content"
    t.index ["mailbox_id"], name: "index_codes_on_mailbox_id"
    t.index ["user_id"], name: "index_codes_on_user_id"
  end

  create_table "mailboxes", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_mailboxes_on_user_id"
  end

  create_table "mails", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mailbox_id"
    t.string  "title"
    t.text    "content"
    t.index ["mailbox_id"], name: "index_mails_on_mailbox_id"
    t.index ["user_id"], name: "index_mails_on_user_id"
  end

  create_table "online_files", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.string "filename"
  end

  create_table "onlines", force: :cascade do |t|
    t.boolean "has_file"
    t.integer "user_id"
    t.index ["user_id"], name: "index_onlines_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "username"
    t.string  "password"
    t.boolean "super"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
