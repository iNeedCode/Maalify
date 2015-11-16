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

ActiveRecord::Schema.define(version: 20151116072707) do

  create_table "budgets", force: :cascade do |t|
    t.string   "title"
    t.integer  "promise",                       default: 0
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "member_id"
    t.integer  "donation_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "rest_promise_from_past_budget", default: 0
  end

  add_index "budgets", ["donation_id"], name: "index_budgets_on_donation_id"
  add_index "budgets", ["member_id"], name: "index_budgets_on_member_id"

  create_table "donations", force: :cascade do |t|
    t.string   "name"
    t.boolean  "budget"
    t.string   "formula"
    t.string   "organization"
    t.integer  "minimum_budget", default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "description"
  end

  add_index "donations", ["name"], name: "index_donations_on_name", unique: true

  create_table "incomes", force: :cascade do |t|
    t.integer  "amount"
    t.date     "starting_date"
    t.integer  "member_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "incomes", ["member_id"], name: "index_incomes_on_member_id"

  create_table "members", primary_key: "aims_id", force: :cascade do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.boolean  "wassiyyat"
    t.date     "date_of_birth"
    t.string   "street"
    t.string   "city"
    t.string   "email"
    t.integer  "plz"
    t.string   "mobile_no"
    t.string   "landline"
    t.string   "occupation"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "gender"
  end

  create_table "receipt_items", force: :cascade do |t|
    t.integer  "receipt_id"
    t.integer  "donation_id"
    t.integer  "amount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "receipt_items", ["donation_id"], name: "index_receipt_items_on_donation_id"
  add_index "receipt_items", ["receipt_id"], name: "index_receipt_items_on_receipt_id"

  create_table "receipts", primary_key: "receipt_id", force: :cascade do |t|
    t.date     "date"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "receipts", ["member_id"], name: "index_receipts_on_member_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
