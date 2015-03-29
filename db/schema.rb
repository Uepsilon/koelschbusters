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

ActiveRecord::Schema.define(version: 20150329173159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "username",         limit: 255
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "activated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
  end

  create_table "events", force: :cascade do |t|
    t.boolean  "internal",    default: true
    t.string   "title",                      null: false
    t.text     "description",                null: false
    t.datetime "starts_at",                  null: false
    t.datetime "ends_at",                    null: false
    t.string   "location",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "position"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "body"
    t.text     "teaser"
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "published_at"
    t.boolean  "internal",                 default: false
    t.integer  "category_id"
    t.time     "notified_at"
  end

  add_index "news", ["internal"], name: "index_news_on_internal", using: :btree
  add_index "news", ["published_at"], name: "index_news_on_published_at", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.boolean  "internal"
    t.integer  "gallery_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "position"
  end

  add_index "pictures", ["internal"], name: "index_pictures_on_internal", using: :btree

  create_table "user_events", force: :cascade do |t|
    t.integer  "event_id",                      null: false
    t.integer  "user_id",                       null: false
    t.boolean  "participation", default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "user_events", ["user_id", "event_id"], name: "index_user_events_on_user_id_and_event_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",       null: false
    t.string   "encrypted_password",     limit: 255, default: "",       null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "first_name",             limit: 255, default: "",       null: false
    t.string   "last_name",              limit: 255, default: "",       null: false
    t.string   "street",                 limit: 255
    t.string   "houseno",                limit: 255
    t.string   "zipcode",                limit: 255
    t.string   "city",                   limit: 255
    t.string   "phone",                  limit: 255
    t.string   "mobile",                 limit: 255
    t.boolean  "member_active",                      default: false
    t.string   "role",                   limit: 255, default: "member", null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "twitter_uid",            limit: 255
    t.string   "twitter_name",           limit: 255
    t.string   "facebook_uid",           limit: 255
    t.string   "facebook_name",          limit: 255
    t.string   "google_uid",             limit: 255
    t.string   "google_name",            limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_uid"], name: "index_users_on_facebook_uid", unique: true, using: :btree
  add_index "users", ["google_uid"], name: "index_users_on_google_uid", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["twitter_uid"], name: "index_users_on_twitter_uid", unique: true, using: :btree

end
