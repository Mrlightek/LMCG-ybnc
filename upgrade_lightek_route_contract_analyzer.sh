#!/bin/bash

set -e

echo "Upgrading Lightek Route Contract Analyzer..."

ROOT="lib/generators/lightek"
HELPERS="$ROOT/helpers"
SCAFFOLD="$ROOT/scaffold"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="$SCAFFOLD/backups/route_contract_upgrade_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "backups" \
  "$HELPERS/" \
  "$BACKUP/helpers/"


echo "Updating RouteAnalyzer..."

cat > "$HELPERS/route_analyzer.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class RouteAnalyzer

        attr_reader :model

        def initialize(model)

          @model = model

        end

        def validate

          issues = []

          route_file = Rails.root.join("config/routes.rb")

          unless File.exist?(route_file)
            issues << [:error, "config/routes.rb not found"]
            return issues
          end

          routes = File.read(route_file)

          resource =
            model.name.underscore.pluralize

          if routes.include?("resources :#{resource}")

            if slug_model?

              unless routes.match?(
                /resources\s+:#{resource}.*param:\s*:slug/m
              )

                issues << [
                  :warning,
                  "#{resource} uses slug but routes do not specify param: :slug"
                ]

              end

            end

          else

            issues << [
              :warning,
              "No resources route found for #{resource}"
            ]

          end

          issues

        end

        private

        def slug_model?

          model.column_names.include?("slug")

        end

      end

    end
  end
end
RUBY


echo "Connecting RouteAnalyzer to ContractValidator..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/helpers/contract_validator.rb")

text = path.read_text()

old = '''
        def check_routes

          return unless has_column?("slug")


          add(
            :info,
            "Slug resource should use param: :slug routes"
          )


        end
'''

new = '''
        def check_routes

          return unless model

          analyzer =
            RouteAnalyzer.new(model)

          analyzer.validate.each do |level, message|

            add(level, message)

          end

        end
'''

if old in text:
    text = text.replace(old, new)

if 'require_relative "route_analyzer"' not in text:
    text = 'require_relative "route_analyzer"\n\n' + text

path.write_text(text)
PY


echo ""
echo "Route Contract Analyzer upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"