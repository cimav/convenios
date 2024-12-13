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

ActiveRecord::Schema[7.1].define(version: 2024_12_11_221824) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agreement_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.integer "owner_id"
    t.text "message"
    t.integer "status", default: 0
    t.boolean "by_system", default: false
    t.datetime "created_at"
    t.index ["agreement_id"], name: "index_agreement_logs_on_agreement_id"
  end

  create_table "agreement_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "has_financial_terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acronym", limit: 5
  end

  create_table "agreements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "agreement_type_id", null: false
    t.integer "creator_id"
    t.string "client_name", null: false
    t.string "client_address", null: false
    t.string "client_type", default: "persona_moral", null: false
    t.string "witness_name", null: false
    t.string "witness_position", null: false
    t.text "objective"
    t.text "obligations"
    t.text "benefits"
    t.date "signature_date", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "status", default: 0
    t.boolean "signed_by_cliente", default: false
    t.boolean "signed_by_solicitante", default: false
    t.boolean "signed_by_director", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code", limit: 10
    t.text "notes"
    t.index ["agreement_type_id"], name: "index_agreements_on_agreement_type_id"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "document_type_id"
    t.bigint "agreement_id", null: false
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agreement_id"], name: "index_documents_on_agreement_id"
  end

  create_table "members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.integer "user_id"
    t.integer "profile"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agreement_id"], name: "index_members_on_agreement_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agreement_logs", "agreements"
  add_foreign_key "agreements", "agreement_types"
  add_foreign_key "documents", "agreements"
  add_foreign_key "members", "agreements"
end
