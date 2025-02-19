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

ActiveRecord::Schema.define(version: 2021_05_27_084814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lending_thankings", force: :cascade do |t|
    t.bigint "lending_id", null: false
    t.bigint "thanking_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lending_id"], name: "index_lending_thankings_on_lending_id"
    t.index ["thanking_id"], name: "index_lending_thankings_on_thanking_id"
  end

  create_table "lendings", force: :cascade do |t|
    t.string "borrower_id", null: false
    t.string "lender_name", null: false
    t.string "content", null: false
    t.boolean "has_returned", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "thankings", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "widgets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "lending_thankings", "lendings"
  add_foreign_key "lending_thankings", "thankings"
end
