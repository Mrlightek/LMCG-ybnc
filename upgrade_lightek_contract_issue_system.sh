#!/bin/bash

set -e

echo "Upgrading Lightek Contract Issue System..."

ROOT="lib/generators/lightek"
HELPERS="$ROOT/helpers"
SCAFFOLD="$ROOT/scaffold"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="$SCAFFOLD/backups/contract_issue_upgrade_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "backups" \
  "$HELPERS/" \
  "$BACKUP/helpers/"


echo "Creating ContractIssue..."

cat > "$HELPERS/contract_issue.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      ContractIssue =
        Struct.new(
          :analyzer,
          :level,
          :message,
          :file,
          :line,
          keyword_init: true
        )

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

if 'require_relative "contract_issue"' not in text:
    text = (
        'require_relative "contract_issue"\n\n'
        + text
    )

old = '''
        def add(level, message)

          @issues << {
            level: level,
            message: message
          }

        end
'''

new = '''
        def add(level, message, analyzer: :contract, file: nil, line: nil)

          @issues << ContractIssue.new(
            analyzer: analyzer,
            level: level,
            message: message,
            file: file,
            line: line
          )

        end
'''

if old in text:
    text = text.replace(old, new)


old_report = '''
          @issues.each do |issue|

            puts "[#{issue[:level].upcase}] #{issue[:message]}"

          end
'''

new_report = '''
          @issues.each do |issue|

            location =
              [
                issue.file,
                issue.line
              ].compact.join(":")


            prefix =
              location.empty? ?
                "" :
                "#{location} "


            puts "#{prefix}[#{issue.level.upcase}] #{issue.message}"

          end
'''

if old_report in text:
    text = text.replace(old_report, new_report)

path.write_text(text)
PY


echo "Updating analyzers to require ContractIssue..."

for FILE in \
  route_analyzer.rb \
  view_analyzer.rb \
  schema_analyzer.rb
do

  TARGET="$HELPERS/$FILE"

  if [ -f "$TARGET" ]; then

    grep -q 'require_relative "contract_issue"' "$TARGET" || \
    sed -i '' '1i\
require_relative "contract_issue"\
' "$TARGET"

  fi

done


echo ""
echo "Contract Issue System upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"