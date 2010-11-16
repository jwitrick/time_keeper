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

ActiveRecord::Schema.define(:version => 20101025170429) do

  create_table "entries", :force => true do |t|
    t.string    "name",        :limit => 30, :null => false
    t.integer   "project_id"
    t.float     "duration"
    t.text      "description"
    t.integer   "user_id"
    t.timestamp "date",                      :null => false
    t.string    "work_type"
  end

  create_table "projects", :force => true do |t|
    t.string  "name",        :limit => 20,                   :null => false
    t.text    "description"
    t.integer "owner_id"
    t.boolean "active",                    :default => true
    t.boolean "chartered",                                   :null => false
    t.integer "team_id"
  end

  create_table "teams", :force => true do |t|
    t.string  "name",     :limit => 30
    t.integer "owner_id",               :null => false
  end

  create_table "users", :force => true do |t|
    t.string  "first_name", :limit => 20,                    :null => false
    t.string  "last_name",  :limit => 20,                    :null => false
    t.string  "username",   :limit => 10,                    :null => false
    t.string  "password",                                    :null => false
    t.string  "email",                                       :null => false
    t.boolean "active",                   :default => true
    t.integer "team_id"
    t.boolean "isAdmin",                  :default => false
    t.boolean "isManager",                :default => false
  end

end
