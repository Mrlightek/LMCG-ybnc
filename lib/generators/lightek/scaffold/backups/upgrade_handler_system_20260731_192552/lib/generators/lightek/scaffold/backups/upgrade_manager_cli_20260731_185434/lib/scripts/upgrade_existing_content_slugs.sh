#!/bin/bash

set -e

echo "Upgrading existing content to slug-based identity..."

TIMESTAMP=$(date +"%Y%m%d%H%M%S")


echo "Creating backups..."

for FILE in \
  app/models/article.rb \
  app/models/resource_item.rb \
  db/seeds/articles.rb \
  db/seeds/resources.rb

do
  if [ -f "$FILE" ]; then
    cp "$FILE" "$FILE.backup.$TIMESTAMP"
  fi
done


echo "Adding slug callbacks..."


python3 <<'PY'
from pathlib import Path


models = [
    "app/models/article.rb",
    "app/models/resource_item.rb"
]


for filename in models:

    path = Path(filename)

    if not path.exists():
        continue

    content = path.read_text()


    if "before_validation" not in content:

        addition = """

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= title.to_s.parameterize
  end

"""

        content = content.rstrip()

        content = content[:-3] + addition + "end\n"


        path.write_text(content)

PY


echo "Creating data migration..."


rails g migration PopulateMissingContentSlugs


MIGRATION=$(ls -t db/migrate/*populate_missing_content_slugs*.rb | head -1)


cat > "$MIGRATION" <<'RUBY'
class PopulateMissingContentSlugs < ActiveRecord::Migration[8.0]

  def up

    Article.where(slug: nil).find_each do |article|
      article.update_columns(
        slug: article.title.to_s.parameterize
      )
    end


    ResourceItem.where(slug: nil).find_each do |resource|
      resource.update_columns(
        slug: resource.title.to_s.parameterize
      )
    end

  end


  def down

    Article.update_all(slug: nil)
    ResourceItem.update_all(slug: nil)

  end

end
RUBY


echo ""
echo "Updating seed support..."


mkdir -p db/seeds


python3 <<'PY'
from pathlib import Path


files = [
    "db/seeds/articles.rb",
    "db/seeds/resources.rb"
]


for file in files:

    path = Path(file)

    if not path.exists():
        continue

    content = path.read_text()

    content = content.replace(
        "title:",
        "slug: title.to_s.parameterize,\n    title:"
    )

    path.write_text(content)

PY


echo ""
echo "Slug upgrade complete."
echo ""
echo "Run:"
echo "rails db:migrate"
echo ""
echo "Then verify:"
echo "rails console"
echo ""
echo "Article.first.slug"
echo "ResourceItem.first.slug"