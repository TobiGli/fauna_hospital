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

ActiveRecord::Schema[8.1].define(version: 2026_11_11_234402) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "medical_records", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.decimal "weight"
    t.decimal "temperature"
    t.text "diagnosis"
    t.text "treatment_plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_medical_records_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.bigint "species_id", null: false
    t.date "admission_date"
    t.string "status"
    t.jsonb "custom_metrics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_id"], name: "index_patients_on_species_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "common_name"
    t.string "scientific_name"
    t.string "taxonomy_class"
    t.string "conservation_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "medical_records", "patients"
  add_foreign_key "patients", "species"
end
