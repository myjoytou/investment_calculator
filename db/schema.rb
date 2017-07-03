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

ActiveRecord::Schema.define(version: 20170703065106) do

  create_table "mutual_funds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nav_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "mutual_fund_id"
    t.integer  "scheme_code"
    t.string   "scheme_name"
    t.decimal  "net_asset_value",  precision: 10
    t.decimal  "repurchase_price", precision: 10
    t.decimal  "sale_price",       precision: 10
    t.datetime "date"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["mutual_fund_id"], name: "index_nav_histories_on_mutual_fund_id", using: :btree
  end

end
