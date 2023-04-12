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

ActiveRecord::Schema[7.0].define(version: 2023_03_24_074107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.bigint "chat_id"
    t.string "title"
    t.string "chat_type"
    t.string "photo"
    t.bigint "reply_markup_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chats_on_chat_id"
    t.index ["reply_markup_message_id"], name: "index_chats_on_reply_markup_message_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "message_id"
    t.bigint "chat_id"
    t.bigint "user_id"
    t.bigint "reply_to_message_id"
    t.datetime "datetime"
    t.json "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["message_id"], name: "index_messages_on_message_id"
    t.index ["reply_to_message_id"], name: "index_messages_on_reply_to_message_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "phone_number"
    t.json "profile_photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_users_on_user_id"
  end

end
