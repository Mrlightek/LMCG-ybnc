#!/bin/bash

set -e

echo "Upgrading Lightek View Contract Analyzer..."

ROOT="lib/generators/lightek"
HELPERS="$ROOT/helpers"
SCAFFOLD="$ROOT/scaffold"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="$SCAFFOLD/backups/view_contract_upgrade_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "backups" \
  "$HELPERS/" \
  "$BACKUP/helpers/"

echo "Creating ViewAnalyzer..."

cat > "$HELPERS/view_analyzer.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class ViewAnalyzer

        attr_reader :model

        def initialize(model)
          @model = model
        end

        def validate

          issues = []

          views =
            Rails.root.join(
              "app/views",
              model.name.underscore.pluralize
            )

          unless Dir.exist?(views)

            issues << [
              :warning,
              "View directory #{views} does not exist"
            ]

            return issues

          end

          required = %w[
            index.html.erb
            show.html.erb
            _form.html.erb
          ]

          required.each do |file|

            unless File.exist?(views.join(file))

              issues << [
                :warning,
                "Missing #{file}"
              ]

            end

          end

          Dir.glob(views.join("**/*.erb")).each do |view|

            body = File.read(view)

            if body.include?("edit_#{model.name.underscore}_path")

              issues << [
                :info,
                "#{File.basename(view)} references edit helper"
              ]

            end

            if slug_model? &&
               body.match?(/\.id\b/)

              issues << [
                :warning,
                "#{File.basename(view)} appears to use id on a slug resource"
              ]

            end

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

echo "Wiring ViewAnalyzer into ContractValidator..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/helpers/contract_validator.rb")
text = path.read_text()

if 'require_relative "view_analyzer"' not in text:
    text = 'require_relative "view_analyzer"\n' + text

old = '''
        def check_views

          add(
            :info,
            "View route compatibility requires inspection"
          )

        end
'''

new = '''
        def check_views

          return unless model

          ViewAnalyzer
            .new(model)
            .validate
            .each do |level, message|

              add(level, message)

            end

        end
'''

if old in text:
    text = text.replace(old, new)

path.write_text(text)
PY

echo ""
echo "View Contract Analyzer upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"