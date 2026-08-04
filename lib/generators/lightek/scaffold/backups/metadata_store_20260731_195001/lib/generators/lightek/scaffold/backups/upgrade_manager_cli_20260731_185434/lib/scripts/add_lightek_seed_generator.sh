#!/bin/bash

set -e

echo "Adding Lightek seed generation..."

BASE="lib/generators/lightek/scaffold"
TEMPLATES="$BASE/templates"

mkdir -p "$TEMPLATES"


# Add seed generator method into scaffold generator
python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/scaffold/scaffold_generator.rb")

content = path.read_text()

method = '''
      def create_seed
        template(
          "seeds.rb",
          "db/seeds/#{plural_name}_seeds.rb"
        )

        append_to_file "db/seeds.rb",
          "\\nrequire_relative \\"seeds/#{plural_name}_seeds\\"\\n"
      end
'''

if "def create_seed" not in content:
    content = content.replace(
        "      def create_views",
        method + "\\n      def create_views"
    )

path.write_text(content)
PY


# Create seed template
cat > "$TEMPLATES/seeds.rb" <<'RUBY'
puts "Creating <%= plural_name %>..."


5.times do |i|

  <%= class_name %>.find_or_create_by!(
<% attributes.each do |attribute| %>
<% unless attribute.type == :references %>
    <%= attribute.name %>: <%= attribute_value(attribute) %>,
<% end %>
<% end %>
  ) do |record|

<% attributes.each do |attribute| %>
<% if attribute.type == :references %>
    record.<%= attribute.name %> = <%= attribute.name.camelize %>.first
<% end %>
<% end %>

  end

end


puts "Created <%= plural_name %>"
RUBY


echo "Seed generation added."

echo ""
echo "Generated output example:"
echo ""
echo "db/seeds/donations_seeds.rb"
echo ""
echo "Run:"
echo "rails db:seed"