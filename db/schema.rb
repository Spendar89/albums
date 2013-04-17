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

ActiveRecord::Schema.define(:version => 20130417191822) do

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.string   "genre"
    t.datetime "release_date"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "album_art"
    t.string   "artist_name"
    t.string   "mb_id"
    t.integer  "artist_id"
    t.boolean  "in_collection"
    t.string   "back_cover"
    t.string   "front_cover"
    t.text     "description"
    t.string   "front_cover_image_file_name"
    t.string   "front_cover_image_content_type"
    t.integer  "front_cover_image_file_size"
    t.datetime "front_cover_image_updated_at"
    t.string   "back_cover_image_file_name"
    t.string   "back_cover_image_content_type"
    t.integer  "back_cover_image_file_size"
    t.datetime "back_cover_image_updated_at"
    t.text     "saved_front_covers"
    t.text     "saved_back_covers"
    t.string   "discogs_id"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "mb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "impressions", :force => true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], :name => "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], :name => "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], :name => "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], :name => "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], :name => "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], :name => "poly_session_index"
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], :name => "impressionable_type_message_index"
  add_index "impressions", ["user_id"], :name => "index_impressions_on_user_id"

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.integer  "position"
    t.integer  "album_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "yt_id"
  end

end
