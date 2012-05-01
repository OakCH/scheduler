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

ActiveRecord::Schema.define(:version => 20120430093026) do

  create_table "admins", :force => true do |t|
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nurse_id"
    t.boolean  "pto",        :default => false
  end

  add_index "events", ["end_at"], :name => "index_events_on_end_at"
  add_index "events", ["nurse_id"], :name => "index_events_on_nurse_id"
  add_index "events", ["start_at"], :name => "index_events_on_start_at"

  create_table "nurse_batons", :force => true do |t|
    t.integer  "nurse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shift"
    t.string   "unit_id"
  end

  create_table "nurses", :force => true do |t|
    t.string  "shift"
    t.integer "unit_id"
    t.integer "position"
    t.integer "num_weeks_off"
    t.integer "years_worked"
  end

  add_index "nurses", ["unit_id", "shift"], :name => "index_nurses_on_unit_id_and_shift"

  create_table "nurses_vacation_days", :id => false, :force => true do |t|
    t.integer "nurse_id"
    t.integer "vacation_day_id"
  end

  create_table "unit_and_shifts", :force => true do |t|
    t.integer "unit_id"
    t.string  "shift"
    t.integer "additional_month"
    t.integer "holiday"
  end

  create_table "units", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "personable_id"
    t.string   "personable_type",                      :default => "Nurse"
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vacation_days", :force => true do |t|
    t.date    "date"
    t.integer "remaining_spots"
    t.string  "shift"
    t.integer "unit_id"
  end

end
