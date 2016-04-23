class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
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
  end
end
