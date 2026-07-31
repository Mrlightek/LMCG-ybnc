class AddSlugToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :slug, :string
  end
end
