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

ActiveRecord::Schema.define(:version => 20130401172346) do

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
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "mb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.integer  "position"
    t.integer  "album_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "yt_id"
  end

end
