#!/bin/bash

set -e

echo "Upgrading public content slug contract..."

TIMESTAMP=$(date +"%Y%m%d%H%M%S")


echo "Creating backups..."

cp config/routes.rb config/routes.rb.backup.$TIMESTAMP
cp app/models/event.rb app/models/event.rb.backup.$TIMESTAMP
cp app/models/initiative.rb app/models/initiative.rb.backup.$TIMESTAMP


# ------------------------------------------------------------
# Create migrations
# ------------------------------------------------------------

echo "Creating slug migrations..."

rails g migration AddSlugToArticles slug:string
rails g migration AddSlugToResourceItems slug:string
rails g migration AddSlugIndexesToPublicContent


# ------------------------------------------------------------
# Patch migration files
# ------------------------------------------------------------

LATEST=$(ls -t db/migrate/*add_slug_indexes_to_public_content*.rb | head -1)

cat > "$LATEST" <<'RUBY'
class AddSlugIndexesToPublicContent < ActiveRecord::Migration[8.0]
  def change
    add_index :initiatives, :slug, unique: true unless index_exists?(:initiatives, :slug)
    add_index :events, :slug, unique: true unless index_exists?(:events, :slug)
    add_index :articles, :slug, unique: true unless index_exists?(:articles, :slug)
    add_index :resource_items, :slug, unique: true unless index_exists?(:resource_items, :slug)
  end
end
RUBY


# ------------------------------------------------------------
# Add to_param helpers
# ------------------------------------------------------------

echo "Adding slug URL support..."


python3 <<'PY'
from pathlib import Path


models = [
    "app/models/event.rb",
    "app/models/initiative.rb",
    "app/models/article.rb",
    "app/models/resource_item.rb"
]


for file in models:

    path = Path(file)

    if not path.exists():
        continue

    content = path.read_text()

    if "def to_param" in content:
        continue

    content = content.rstrip()

    if content.endswith("end"):
        content = content[:-3]

    content += """

  def to_param
    slug
  end

end
"""

    path.write_text(content)

PY


# ------------------------------------------------------------
# Update routes
# ------------------------------------------------------------

echo "Updating routes..."

python3 <<'PY'
from pathlib import Path

path = Path("config/routes.rb")

content = path.read_text()

content = content.replace(
    "resources :events, only: [:index, :show]",
    "resources :events, param: :slug, only: [:index, :show]"
)

content = content.replace(
    "resources :initiatives, only: [:index, :show]",
    "resources :initiatives, param: :slug, only: [:index, :show]"
)

content = content.replace(
    "resources :articles",
    "resources :articles, param: :slug"
)

content = content.replace(
    'resources :resource_items, only: [:index], path: "library"',
    'resources :resource_items, param: :slug, only: [:index], path: "library"'
)

path.write_text(content)

PY


echo ""
echo "Slug contract upgrade complete."
echo ""
echo "Next steps:"
echo "1. Review migrations"
echo "2. Run: rails db:migrate"
echo "3. Update seeds to generate slugs for articles/resource_items"
echo "4. Run: rails routes | grep events"