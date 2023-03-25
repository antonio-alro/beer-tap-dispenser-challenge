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

ActiveRecord::Schema[7.0].define(version: 2023_03_22_115138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "dispensers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status", limit: 15, null: false
    t.decimal "flow_volume", precision: 10, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_dispensers_on_created_at"
  end

  create_table "usages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dispenser_id"
    t.datetime "opened_at", null: false
    t.datetime "closed_at"
    t.decimal "flow_volume", precision: 10, scale: 6, null: false
    t.decimal "total_spent", precision: 10, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["closed_at"], name: "index_usages_on_closed_at"
    t.index ["created_at"], name: "index_usages_on_created_at"
    t.index ["dispenser_id"], name: "index_usages_on_dispenser_id"
  end

end
