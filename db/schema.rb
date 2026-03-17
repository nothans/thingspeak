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

ActiveRecord::Schema[8.0].define(version: 2026_03_17_024828) do
  create_table "active_admin_comments", charset: "latin1", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", limit: 50, null: false
    t.string "resource_type", limit: 50, null: false
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", charset: "latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_keys", charset: "latin1", force: :cascade do |t|
    t.string "api_key", limit: 16
    t.integer "channel_id"
    t.integer "user_id"
    t.boolean "write_flag", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "note"
    t.index ["api_key"], name: "index_api_keys_on_api_key", unique: true
    t.index ["channel_id"], name: "index_api_keys_on_channel_id"
  end

  create_table "channels", charset: "latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "description"
    t.decimal "latitude", precision: 15, scale: 10
    t.decimal "longitude", precision: 15, scale: 10
    t.string "field1"
    t.string "field2"
    t.string "field3"
    t.string "field4"
    t.string "field5"
    t.string "field6"
    t.string "field7"
    t.string "field8"
    t.integer "scale1"
    t.integer "scale2"
    t.integer "scale3"
    t.integer "scale4"
    t.integer "scale5"
    t.integer "scale6"
    t.integer "scale7"
    t.integer "scale8"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "elevation"
    t.integer "last_entry_id"
    t.boolean "public_flag", default: false
    t.string "options1"
    t.string "options2"
    t.string "options3"
    t.string "options4"
    t.string "options5"
    t.string "options6"
    t.string "options7"
    t.string "options8"
    t.boolean "social", default: false
    t.string "slug"
    t.string "status"
    t.string "url"
    t.string "video_id"
    t.string "video_type"
    t.boolean "clearing", default: false, null: false
    t.integer "ranking"
    t.string "user_agent"
    t.string "realtime_io_serial_number", limit: 36
    t.text "metadata"
    t.datetime "last_write_at"
    t.index ["latitude", "longitude"], name: "index_channels_on_latitude_and_longitude"
    t.index ["public_flag", "last_entry_id", "updated_at"], name: "channels_public_viewable"
    t.index ["ranking", "updated_at"], name: "index_channels_on_ranking_and_updated_at"
    t.index ["realtime_io_serial_number"], name: "index_channels_on_realtime_io_serial_number"
    t.index ["slug"], name: "index_channels_on_slug"
    t.index ["user_id"], name: "index_channels_on_user_id"
  end

  create_table "commands", charset: "latin1", force: :cascade do |t|
    t.string "command_string"
    t.integer "position"
    t.integer "talkback_id"
    t.datetime "executed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["talkback_id", "executed_at"], name: "index_commands_on_talkback_id_and_executed_at"
  end

  create_table "comments", charset: "latin1", force: :cascade do |t|
    t.integer "parent_id"
    t.text "body"
    t.integer "flags"
    t.integer "user_id"
    t.string "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "channel_id"
    t.index ["channel_id"], name: "index_comments_on_channel_id"
  end

  create_table "daily_feeds", charset: "latin1", force: :cascade do |t|
    t.integer "channel_id"
    t.date "date"
    t.string "calculation", limit: 20
    t.string "result"
    t.integer "field", limit: 1
    t.index ["channel_id", "date"], name: "index_daily_feeds_on_channel_id_and_date"
  end

  create_table "devices", charset: "latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "model"
    t.string "ip_address"
    t.integer "port"
    t.string "mac_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "local_ip_address"
    t.integer "local_port"
    t.string "default_gateway"
    t.string "subnet_mask"
    t.index ["mac_address"], name: "index_devices_on_mac_address"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "failedlogins", charset: "latin1", force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.string "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", charset: "latin1", force: :cascade do |t|
    t.integer "channel_id"
    t.string "field1"
    t.string "field2"
    t.string "field3"
    t.string "field4"
    t.string "field5"
    t.string "field6"
    t.string "field7"
    t.string "field8"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "entry_id"
    t.string "status"
    t.decimal "latitude", precision: 15, scale: 10
    t.decimal "longitude", precision: 15, scale: 10
    t.string "elevation"
    t.string "location"
    t.index ["channel_id", "created_at"], name: "index_feeds_on_channel_id_and_created_at"
    t.index ["channel_id", "entry_id"], name: "index_feeds_on_channel_id_and_entry_id"
  end

  create_table "headers", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "thinghttp_id"
    t.index ["thinghttp_id"], name: "index_headers_on_thinghttp_id"
  end

  create_table "pipes", charset: "latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "slug", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "parse"
    t.integer "cache"
    t.index ["slug"], name: "index_pipes_on_slug"
  end

  create_table "reacts", charset: "latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "react_type", limit: 10
    t.integer "run_interval"
    t.boolean "run_on_insertion", default: true, null: false
    t.datetime "last_run_at"
    t.integer "channel_id"
    t.integer "field_number"
    t.string "condition", limit: 15
    t.string "condition_value"
    t.float "condition_lat"
    t.float "condition_long"
    t.float "condition_elev"
    t.integer "actionable_id"
    t.boolean "last_result", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "actionable_type", default: "Thinghttp"
    t.string "action_value"
    t.string "latest_value"
    t.boolean "activated", default: true
    t.boolean "run_action_every_time", default: false
    t.index ["channel_id", "run_on_insertion"], name: "index_reacts_on_channel_id_and_run_on_insertion"
    t.index ["channel_id"], name: "index_reacts_on_channel_id"
    t.index ["run_interval"], name: "index_reacts_on_run_interval"
    t.index ["user_id"], name: "index_reacts_on_user_id"
  end

  create_table "scheduled_thinghttps", charset: "latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.boolean "activated", default: true, null: false
    t.integer "run_interval"
    t.integer "thinghttp_id"
    t.integer "channel_id"
    t.string "field_name"
    t.datetime "last_run_at"
    t.string "last_result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["activated", "run_interval"], name: "index_scheduled_thinghttps_on_activated_and_run_interval"
    t.index ["user_id"], name: "index_scheduled_thinghttps_on_user_id"
  end

  create_table "taggings", charset: "latin1", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["channel_id"], name: "index_taggings_on_channel_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "talkbacks", charset: "latin1", force: :cascade do |t|
    t.string "api_key", limit: 16
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "name"
    t.integer "channel_id"
    t.index ["api_key"], name: "index_talkbacks_on_api_key"
    t.index ["user_id"], name: "index_talkbacks_on_user_id"
  end

  create_table "thinghttps", charset: "latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "api_key", limit: 16
    t.text "url"
    t.string "auth_name"
    t.string "auth_pass"
    t.string "method"
    t.string "content_type"
    t.string "http_version"
    t.string "host"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "parse"
    t.index ["api_key"], name: "index_thinghttps_on_api_key"
    t.index ["user_id"], name: "index_thinghttps_on_user_id"
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "login", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "password_salt"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "time_zone"
    t.boolean "public_flag", default: false
    t.text "bio"
    t.string "website"
    t.string "api_key", limit: 16
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.string "authentication_token"
    t.index ["api_key"], name: "index_users_on_api_key"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "watchings", charset: "latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "channel_id"], name: "index_watchings_on_user_id_and_channel_id"
  end

  create_table "windows", charset: "latin1", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "html"
    t.integer "col"
    t.string "title"
    t.string "window_type"
    t.string "name"
    t.boolean "private_flag", default: false
    t.boolean "show_flag", default: true
    t.integer "content_id"
    t.text "options"
    t.index ["channel_id"], name: "index_windows_on_channel_id"
    t.index ["window_type", "content_id"], name: "index_windows_on_window_type_and_content_id"
  end
end
