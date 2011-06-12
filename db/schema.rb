# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110605020639) do

  create_table "actions", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["user_id"], :name => "index_activity_on_user_id"

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.binary   "data",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "filename"
  end

  add_index "assets", ["name"], :name => "index_assets_on_name"
  add_index "assets", ["user_id"], :name => "index_assets_on_user_id"

  create_table "friendships", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "function_versions", :force => true do |t|
    t.integer  "public_function_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "code",               :limit => 2147483647
  end

  add_index "function_versions", ["public_function_id"], :name => "index_function_versions_on_function_id"
  add_index "function_versions", ["user_id"], :name => "index_function_versions_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message",    :limit => 2147483647
  end

  add_index "messages", ["program_id"], :name => "index_messages_on_program_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text",       :limit => 2147483647
  end

  add_index "page_versions", ["page_id"], :name => "index_page_versions_on_page_id"
  add_index "page_versions", ["user_id"], :name => "index_page_versions_on_user_id"

  create_table "pages", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "text",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["name"], :name => "index_pages_on_name"
  add_index "pages", ["user_id"], :name => "index_pages_on_user_id"

  create_table "program_versions", :force => true do |t|
    t.integer  "program_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "start_code", :limit => 2147483647
    t.text     "loop_code",  :limit => 2147483647
  end

  add_index "program_versions", ["program_id"], :name => "index_program_versions_on_program_id"
  add_index "program_versions", ["user_id"], :name => "index_program_versions_on_user_id"

  create_table "programs", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "start_code", :limit => 2147483647
    t.text     "loop_code",  :limit => 2147483647
  end

  add_index "programs", ["name"], :name => "index_programs_on_name"
  add_index "programs", ["user_id"], :name => "index_programs_on_user_id"

  create_table "public_functions", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.text    "code",    :limit => 2147483647
  end

  add_index "public_functions", ["name"], :name => "index_functions_on_name"
  add_index "public_functions", ["user_id"], :name => "index_functions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "facebook_id"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "salt"
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["name"], :name => "index_users_on_name"

end
