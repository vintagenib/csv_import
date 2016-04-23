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

ActiveRecord::Schema.define(version: 20160423001502) do

  create_table "customers", force: :cascade do |t|
    t.integer  "site_id",          limit: 4
    t.integer  "nah_account_id",   limit: 4
    t.string   "sold_to_name",     limit: 255
    t.string   "sold_to_company",  limit: 255
    t.string   "sold_to_address1", limit: 255
    t.string   "sold_to_address2", limit: 255
    t.string   "sold_to_city",     limit: 255
    t.string   "sold_to_state",    limit: 25
    t.string   "sold_to_zip",      limit: 12
    t.string   "phone",            limit: 255
    t.string   "email",            limit: 255
    t.string   "contact",          limit: 255
    t.string   "fax",              limit: 255
    t.text     "info",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "ship_to_name",     limit: 255
    t.string   "ship_to_company",  limit: 255
    t.string   "ship_to_address1", limit: 255
    t.string   "ship_to_address2", limit: 255
    t.string   "ship_to_city",     limit: 255
    t.string   "ship_to_state",    limit: 25
    t.string   "ship_to_zip",      limit: 12
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

end
