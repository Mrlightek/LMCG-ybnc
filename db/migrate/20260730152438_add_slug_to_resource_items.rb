class AddSlugToResourceItems < ActiveRecord::Migration[8.0]
  def change
    add_column :resource_items, :slug, :string
  end
end
