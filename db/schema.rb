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

ActiveRecord::Schema.define(version: 2021_10_11_091206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "data_rows", force: :cascade do |t|
    t.jsonb "values"
    t.integer "row_type"
    t.bigint "file_import_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["file_import_id"], name: "index_data_rows_on_file_import_id"
  end

  create_table "destination_files", force: :cascade do |t|
    t.bigint "reconcile_transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reconcile_transaction_id"], name: "index_destination_files_on_reconcile_transaction_id"
  end

  create_table "file_imports", force: :cascade do |t|
    t.integer "import_type"
    t.bigint "reconcile_transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reconcile_transaction_id"], name: "index_file_imports_on_reconcile_transaction_id"
  end

  create_table "reconcile_transactions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "source_files", force: :cascade do |t|
    t.bigint "reconcile_transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reconcile_transaction_id"], name: "index_source_files_on_reconcile_transaction_id"
  end

  create_table "summaries", force: :cascade do |t|
    t.jsonb "detail_data"
    t.jsonb "source_columns"
    t.jsonb "destination_columns"
    t.jsonb "result_columns"
    t.integer "summary_type"
    t.bigint "reconcile_transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reconcile_transaction_id"], name: "index_summaries_on_reconcile_transaction_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "data_rows", "file_imports"
  add_foreign_key "destination_files", "reconcile_transactions"
  add_foreign_key "file_imports", "reconcile_transactions"
  add_foreign_key "source_files", "reconcile_transactions"
  add_foreign_key "summaries", "reconcile_transactions"
end
