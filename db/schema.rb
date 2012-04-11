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

ActiveRecord::Schema.define(:version => 20120411051747) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nurse_id"
  end

  create_table "nurses", :force => true do |t|
    t.string   "name"
    t.string   "shift"
    t.integer  "unit_id"
    t.integer  "seniority"
    t.integer  "num_weeks_off"
    t.string   "email"
    t.integer  "years_worked"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  add_index "nurses", ["email"], :name => "index_nurses_on_email", :unique => true
  add_index "nurses", ["reset_password_token"], :name => "index_nurses_on_reset_password_token", :unique => true

  create_table "nurses_vacation_days", :id => false, :force => true do |t|
    t.integer "nurse_id"
    t.integer "vacation_day_id"
  end

  create_table "units", :force => true do |t|
    t.string "name"
  end

  create_table "vacation_days", :force => true do |t|
    t.date    "date"
    t.integer "remaining_spots"
    t.string  "shift"
    t.integer "unit_id"
  end

end
