# ── db/migrate/XXXXXX_create_contact_messages.rb ─────────────────

class AddToContactMessage < ActiveRecord::Migration[8.0]
  def change
    change_table :contact_messages do |t|
      t.string  :name,         null: false
      t.string  :email,        null: false
      t.string  :organization
      t.string  :inquiry_type, default: "general"
      t.text    :message,      null: false
      t.boolean :read,         default: false
    end
    add_index :contact_messages, :read
    add_index :contact_messages, :created_at
  end
end
