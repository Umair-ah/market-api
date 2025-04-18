# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_18_085128) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "negotiations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "proposal_id", null: false
    t.decimal "price", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_negotiations_on_proposal_id"
    t.index ["user_id"], name: "index_negotiations_on_user_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.string "title"
    t.decimal "quantity"
    t.string "unit"
    t.decimal "price", precision: 7, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_proposals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "role"
    t.string "district"
    t.string "taluka"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "negotiations", "proposals"
  add_foreign_key "negotiations", "users"
  add_foreign_key "proposals", "users"
end
