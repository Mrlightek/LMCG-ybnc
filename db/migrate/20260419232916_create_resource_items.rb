# ── db/migrate/XXXXXX_create_resource_items.rb ───────────────────

class CreateResourceItems < ActiveRecord::Migration[8.0]
  def change
    create_table :resource_items do |t|
      t.string  :title,       null: false
      t.text    :description
      t.string  :category,    null: false
      t.string  :external_url
      t.boolean :published,   default: false
      t.boolean :featured,    default: false
      t.integer :sort_order,  default: 0
    end
    add_index :resource_items, :category
    add_index :resource_items, :published
  end
end
