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

ActiveRecord::Schema.define(:version => 20151124214735) do

  create_table "consensuspolygons", :force => true do |t|
    t.string   "task"
    t.integer  "flaggable_id"
    t.text     "consensus"
    t.integer  "override_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "flaggable_type", :default => "Polygon"
  end

  add_index "consensuspolygons", ["flaggable_id", "task"], :name => "index_task_consensus_on_polygon_id", :unique => true
  add_index "consensuspolygons", ["task"], :name => "index_task"

  create_table "flags", :force => true do |t|
    t.string   "flag_type"
    t.integer  "flaggable_id"
    t.string   "session_id"
    t.text     "flag_value"
    t.boolean  "is_primary"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.decimal  "latitude",       :precision => 15, :scale => 12
    t.decimal  "longitude",      :precision => 15, :scale => 12
    t.string   "flaggable_type",                                 :default => "Polygon"
  end

  add_index "flags", ["flaggable_id"], :name => "polygon_index"
  add_index "flags", ["session_id", "flag_type", "flaggable_id", "flag_value", "latitude", "longitude"], :name => "index_flags_on_session_id", :unique => true

  create_table "layers", :force => true do |t|
    t.string   "name"
    t.string   "tilejson"
    t.string   "description"
    t.string   "year"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "bbox"
    t.integer  "external_id"
    t.string   "tileset_type", :default => "tms"
  end

  create_table "polygons", :force => true do |t|
    t.text     "geometry"
    t.text     "vectorizer_json"
    t.integer  "sheet_id"
    t.string   "color"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.integer  "dn"
    t.integer  "flag_count",                                      :default => 0
    t.decimal  "centroid_lat",    :precision => 15, :scale => 12
    t.decimal  "centroid_lon",    :precision => 15, :scale => 12
  end

  create_table "sheets", :force => true do |t|
    t.string   "bbox"
    t.string   "map_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "layer_id"
  end

  add_index "sheets", ["layer_id"], :name => "index_sheets_on_layer_id"

  create_table "user_scores", :force => true do |t|
    t.integer  "user_id"
    t.string   "flag_type"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_scores", ["user_id", "flag_type"], :name => "user_task_index", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",          :null => false
    t.string   "encrypted_password",     :default => "",          :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "provider",               :default => "google"
    t.string   "uid"
    t.string   "name"
    t.string   "role",                   :default => "inspector"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "usersessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
