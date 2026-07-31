#!/bin/bash

set -e

echo "Upgrading Lightek seed engine..."

GENERATOR="lib/generators/lightek/scaffold"
BACKUP="$GENERATOR/backups/seed_engine_upgrade_$(date +%Y%m%d_%H%M%S)"


mkdir -p "$BACKUP"


echo "Creating backup..."

cp db/seeds.rb "$BACKUP/" 2>/dev/null || true



echo "Creating seed directory..."

mkdir -p db/seeds



echo "Creating seed loader..."


cat > db/seeds.rb <<'RUBY'
puts "Loading Lightek seeds..."

Dir[
  Rails.root.join(
    "db/seeds/*_seeds.rb"
  )
].sort.each do |seed|

  load seed

end


puts "Lightek seeds complete."
RUBY



echo "Creating seed helper..."


mkdir -p lib/generators/lightek/helpers


cat > lib/generators/lightek/helpers/seed_generator.rb <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class SeedGenerator


        def initialize(model)

          @model = model

        end


        def ignored_columns

          %w[
            id
            created_at
            updated_at
          ]

        end



        def columns

          @model.constantize
            .columns
            .reject do |column|

              ignored_columns.include?(
                column.name
              )

            end

        end


      end

    end
  end
end
RUBY



echo "Creating generator seed template..."


mkdir -p "$GENERATOR/templates"


cat > "$GENERATOR/templates/seeds.rb" <<'RUBY'
puts "Seeding <%= class_name %>..."


5.times do |i|

  <%= class_name %>.create!(

<% attributes.each do |attribute| %>

    <%= attribute.name %>:
      <%= attribute_value(attribute) %>,

<% end %>

  )

end


puts "<%= class_name %> seeded."
RUBY



echo "Updating scaffold generator..."


python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()


require_line = 'require_relative "../../helpers/seed_generator"\n'


if "seed_generator" not in content:

    content = require_line + content



path.write_text(content)

PY



echo ""
echo "Seed engine upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"