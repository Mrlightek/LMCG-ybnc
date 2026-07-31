#!/bin/bash

set -e

echo "Upgrading Lightek Ability Contract Analyzer..."

ROOT="lib/generators/lightek"
HELPERS="$ROOT/helpers"
SCAFFOLD="$ROOT/scaffold"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="$SCAFFOLD/backups/ability_contract_upgrade_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "backups" \
  "$HELPERS/" \
  "$BACKUP/helpers/"


echo "Creating AbilityAnalyzer..."

cat > "$HELPERS/ability_analyzer.rb" <<'RUBY'
require_relative "contract_issue"

module Lightek
  module Generators
    module Helpers

      class AbilityAnalyzer

        attr_reader :model

        def initialize(model)
          @model = model
        end

        def validate

          issues = []

          check_ability_file(issues)
          check_controller_authorize(issues)

          issues

        end

        private

        def check_ability_file(issues)

          file =
            Rails.root.join(
              "app/models/abilities/#{model.name.underscore}_ability.rb"
            )

          unless File.exist?(file)

            issues << ContractIssue.new(
              analyzer: :ability,
              level: :warning,
              message: "Missing ability file",
              file: file.to_s
            )

          end

        end

        def check_controller_authorize(issues)

          controller =
            Rails.root.join(
              "app/controllers/#{model.name.underscore.pluralize}_controller.rb"
            )

          return unless File.exist?(controller)

          body = File.read(controller)

          unless body.include?("authorize!")

            issues << ContractIssue.new(
              analyzer: :ability,
              level: :warning,
              message: "Controller does not invoke authorize!",
              file: controller.to_s
            )

          end

        end

      end

    end
  end
end
RUBY


echo "Updating ContractValidator..."

python3 <<'PY'
from pathlib import Path

path = Path(
"lib/generators/lightek/helpers/contract_validator.rb"
)

text = path.read_text()

if 'require_relative "ability_analyzer"' not in text:
    text = (
        'require_relative "ability_analyzer"\n'
        + text
    )

old = '''
        def check_authorization

          add(
            :info,
            "Authorization contract pending controller scan"
          )

        end
'''

new = '''
        def check_authorization

          return unless model

          AbilityAnalyzer
            .new(model)
            .validate
            .each do |issue|

              @issues << issue

            end

        end
'''

if old in text:
    text = text.replace(old,new)

path.write_text(text)
PY


echo ""
echo "Ability Contract Analyzer upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"