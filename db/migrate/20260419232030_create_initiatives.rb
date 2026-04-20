# ── db/migrate/XXXXXX_create_initiatives.rb ──────────────────────

class CreateInitiatives < ActiveRecord::Migration[8.0]
  def change
    create_table :initiatives do |t|
      t.string  :title,       null: false
      t.string  :slug
      t.text    :description
      t.text    :impact
      t.string  :status,      null: false, default: "active"
      t.string  :focus_area,  null: false
      t.string  :call_to_action
      t.string  :cta_link
      t.date    :start_date
      t.date    :end_date
      t.boolean :published,   default: false
      t.boolean :featured,    default: false
      t.integer :sort_order,  default: 0

      t.timestamps
    end
    add_index :initiatives, :status
    add_index :initiatives, :focus_area
  end
end