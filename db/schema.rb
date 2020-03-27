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

ActiveRecord::Schema.define(version: 2020_03_27_084556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "outputs", force: :cascade do |t|
    t.string "block_hash"
    t.decimal "capacity", precision: 30
    t.boolean "cellbase"
    t.string "lock_args"
    t.string "lock_code_hash"
    t.string "lock_hash_type"
    t.string "type_args"
    t.string "type_code_hash"
    t.string "type_hash_type"
    t.integer "cell_index"
    t.string "tx_hash"
    t.binary "data"
    t.integer "output_data_len"
    t.integer "cell_type", default: 0
    t.string "lock_hash"
    t.string "type_hash"
    t.integer "status", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sync_infos", force: :cascade do |t|
    t.bigint "tip_block_number"
    t.string "tip_block_hash"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
