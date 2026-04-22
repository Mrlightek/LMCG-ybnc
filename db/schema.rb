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

ActiveRecord::Schema[8.0].define(version: 2026_04_22_213132) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contact_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "organization"
    t.string "inquiry_type", default: "general"
    t.text "message", null: false
    t.boolean "read", default: false
    t.index ["created_at"], name: "index_contact_messages_on_created_at"
    t.index ["read"], name: "index_contact_messages_on_read"
  end

  create_table "dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.text "description"
    t.text "details"
    t.string "event_type", null: false
    t.date "event_date", null: false
    t.time "start_time"
    t.time "end_time"
    t.string "location_name"
    t.string "location_address"
    t.string "city", default: "Vallejo"
    t.string "state", default: "CA"
    t.boolean "is_online", default: false
    t.string "meeting_link"
    t.boolean "is_free", default: true
    t.decimal "cost", precision: 8, scale: 2
    t.string "rsvp_link"
    t.boolean "published", default: false
    t.boolean "featured", default: false
    t.string "slug"
    t.index ["event_date"], name: "index_events_on_event_date"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["published"], name: "index_events_on_published"
    t.index ["slug"], name: "index_events_on_slug", unique: true
  end

  create_table "initiatives", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug"
    t.text "description"
    t.text "impact"
    t.string "status", default: "active", null: false
    t.string "focus_area", null: false
    t.string "call_to_action"
    t.string "cta_link"
    t.date "start_date"
    t.date "end_date"
    t.boolean "published", default: false
    t.boolean "featured", default: false
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["focus_area"], name: "index_initiatives_on_focus_area"
    t.index ["status"], name: "index_initiatives_on_status"
  end

  create_table "landing_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "first_name"
    t.string "status", default: "active"
    t.string "token"
    t.string "source"
    t.datetime "unsubscribed_at"
    t.index ["email"], name: "index_newsletter_subscriptions_on_email", unique: true
    t.index ["status"], name: "index_newsletter_subscriptions_on_status"
    t.index ["token"], name: "index_newsletter_subscriptions_on_token", unique: true
  end

  create_table "resource_items", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "category", null: false
    t.string "external_url"
    t.boolean "published", default: false
    t.boolean "featured", default: false
    t.integer "sort_order", default: 0
    t.index ["category"], name: "index_resource_items_on_category"
    t.index ["published"], name: "index_resource_items_on_published"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "volunteer_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "city"
    t.string "state"
    t.json "skill_areas", default: []
    t.text "why_join"
    t.text "skills_description"
    t.boolean "can_donate_time", default: false
    t.string "availability"
    t.string "status", default: "pending"
    t.text "internal_notes"
    t.index ["email"], name: "index_volunteer_applications_on_email"
    t.index ["status"], name: "index_volunteer_applications_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "sessions", "users"
end
