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

ActiveRecord::Schema[8.1].define(version: 2026_08_14_235434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "shoe_variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "shoe_id", null: false
    t.bigint "size_id", null: false
    t.integer "stock_quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["shoe_id", "size_id"], name: "index_shoe_variants_on_shoe_id_and_size_id", unique: true
    t.index ["shoe_id"], name: "index_shoe_variants_on_shoe_id"
    t.index ["size_id"], name: "index_shoe_variants_on_size_id"
  end

  create_table "shoes", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "brand_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "gender", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_shoes_on_brand_id"
    t.index ["category_id"], name: "index_shoes_on_category_id"
    t.index ["name", "brand_id"], name: "index_shoes_on_name_and_brand_id", unique: true
  end

  create_table "sizes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label", null: false
    t.datetime "updated_at", null: false
    t.decimal "value_cm", precision: 5, scale: 2, null: false
    t.index ["value_cm"], name: "index_sizes_on_value_cm", unique: true
  end

  add_foreign_key "shoe_variants", "shoes"
  add_foreign_key "shoe_variants", "sizes"
  add_foreign_key "shoes", "categories"
end
