#!/bin/bash

set -e

echo "Wiring Lightek scaffold engine..."

GENERATOR="lib/generators/lightek/scaffold/scaffold_generator.rb"

if [ ! -f "$GENERATOR" ]; then
  echo "ERROR: $GENERATOR not found"
  exit 1
fi

cp "$GENERATOR" "${GENERATOR}.backup"

echo "Backup created:"
echo "${GENERATOR}.backup"

python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/scaffold/scaffold_generator.rb")

content = path.read_text()

# Add helper requires
requires = """require_relative "../helpers/schema_analyzer"
require_relative "../helpers/route_analyzer"
require_relative "../helpers/ability_generator"
require_relative "../helpers/view_generator"

"""

if "schema_analyzer" not in content:
    content = content.replace(
        'require "rails/generators"\n\n',
        'require "rails/generators"\n\n' + requires
    )

# Add analyzer methods before private
methods = r'''
      def analyze_contract
        model = file_name.classify

        say ""
        say "Lightek Contract Analysis"
        say "-------------------------"
        say "Model: #{model}"

        begin
          schema = Lightek::Generators::Helpers::SchemaAnalyzer.new(model)

          say "Columns:"
          schema.columns.each do |column|
            say "  ✓ #{column}"
          end

        rescue NameError
          say "  Model not loaded yet."
        end

        say ""
      end


      def create_ability

        template(
          "abilities/ability.rb",
          "app/models/abilities/#{file_name}_ability.rb"
        )

      end

'''

if "def analyze_contract" not in content:
    content = content.replace(
        "      private",
        methods + "      private"
    )

# Fix private placement if generator currently has malformed ending
content = content.replace(
    "\nend\n\n      private",
    "\n\n      private"
)

path.write_text(content)
PY


echo "Lightek scaffold engine wired."
echo ""
echo "Next test:"
echo "rails g lightek:scaffold TestThing name:string published:boolean"