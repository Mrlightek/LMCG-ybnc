class AddSlugIndexesToPublicContent < ActiveRecord::Migration[8.0]
  def change
    add_index :initiatives, :slug, unique: true unless index_exists?(:initiatives, :slug)
    add_index :events, :slug, unique: true unless index_exists?(:events, :slug)
    add_index :articles, :slug, unique: true unless index_exists?(:articles, :slug)
    add_index :resource_items, :slug, unique: true unless index_exists?(:resource_items, :slug)
  end
end
