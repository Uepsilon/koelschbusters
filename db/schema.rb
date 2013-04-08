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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130408203618) do

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "teaser"
    t.integer  "user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "published_at"
    t.boolean  "internal",     :default => false
  end

  add_index "news", ["internal"], :name => "index_news_on_internal"
  add_index "news", ["published_at"], :name => "index_news_on_published_at"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",       :null => false
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name",             :default => "",       :null => false
    t.string   "last_name",              :default => "",       :null => false
    t.string   "address"
    t.string   "houseno"
    t.string   "zipcode"
    t.string   "city"
    t.string   "phone"
    t.string   "mobile"
    t.boolean  "member_active",          :default => false
    t.string   "role",                   :default => "member", :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
