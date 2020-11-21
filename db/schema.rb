# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_21_131821) do

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "subject"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string "amount"
    t.string "invoice_pdf"
    t.string "invoice_number"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_invoice_valid"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "left_user_id"
    t.integer "right_user_id"
    t.integer "user_id"
    t.boolean "is_left_verified"
    t.boolean "is_right_verified"
    t.index ["left_user_id"], name: "index_pairs_on_left_user_id"
    t.index ["right_user_id"], name: "index_pairs_on_right_user_id"
    t.index ["user_id"], name: "index_pairs_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "user_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token"
    t.string "name"
    t.string "dob"
    t.string "sponser_id"
    t.string "position"
    t.string "address"
    t.string "country_code"
    t.string "phone_number"
    t.string "pan_number"
    t.string "gender"
    t.string "zipcode"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "ancestry"
    t.integer "sponsered_by_id"
    t.string "invoice_number"
    t.integer "role_id"
    t.boolean "is_invoice_valid"
    t.string "unique_user_id"
    t.string "upl_id"
    t.integer "h_parent"
    t.string "upi_id"
    t.index "\"left_user_id\"", name: "index_users_on_left_user_id"
    t.index "\"right_user_id\"", name: "index_users_on_right_user_id"
    t.index ["ancestry"], name: "index_users_on_ancestry"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["sponsered_by_id"], name: "index_users_on_sponsered_by_id"
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  add_foreign_key "invoices", "users"
  add_foreign_key "users", "roles"
end
