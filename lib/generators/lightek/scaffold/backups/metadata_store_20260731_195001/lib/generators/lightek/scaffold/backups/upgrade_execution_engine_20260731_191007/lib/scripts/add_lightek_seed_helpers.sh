#!/bin/bash

set -e

echo "Adding Lightek generator seed helpers..."

GENERATOR="lib/generators/lightek/scaffold/scaffold_generator.rb"

if [ ! -f "$GENERATOR" ]; then
  echo "Error: $GENERATOR not found"
  exit 1
fi


python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/scaffold/scaffold_generator.rb")

content = path.read_text()

helper = '''

      private

      def attribute_value(attribute)

        case attribute.type.to_sym

        when :string
          "\"Example #{attribute.name}\""

        when :text
          "\"Example text for #{attribute.name}\""

        when :integer
          "rand(1..100)"

        when :decimal
          "rand(10.0..500.0).round(2)"

        when :float
          "rand(1.0..100.0)"

        when :boolean
          "true"

        when :references
          "#{attribute.name.camelize}.first"

        else
          "nil"

        end

      end

'''

if "def attribute_value" not in content:
    content = content.rstrip()
    
    if content.endswith("end"):
        content = content[:-3] + helper + "\nend\n"

path.write_text(content)
PY


echo "Seed helper added."
echo ""
echo "The generator can now resolve:"
echo "  string      -> example text"
echo "  text        -> example text"
echo "  integer     -> random number"
echo "  decimal     -> random decimal"
echo "  boolean     -> true"
echo "  references  -> associated model"