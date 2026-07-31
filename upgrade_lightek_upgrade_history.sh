#!/usr/bin/env bash

set -e

echo "Adding Lightek Upgrade History..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_history_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating history layer..."

mkdir -p lib/lightek/upgrades


cat > lib/lightek/upgrades/execution_record.rb <<'RUBY'
module Lightek
  module Upgrades

    ExecutionRecord =
      Struct.new(
        :name,
        :version,
        :status,
        :message,
        :executed_at,
        keyword_init: true
      )

  end
end
RUBY


cat > lib/lightek/upgrades/history.rb <<'RUBY'
module Lightek
  module Upgrades

    class History

      @records = []


      class << self

        attr_reader :records


        def record(attributes)

          @records << ExecutionRecord.new(
            **attributes,
            executed_at: Time.now
          )

        end


        def all

          @records

        end


        def applied?(name, version=nil)

          @records.any? do |record|

            record.name.to_s == name.to_s &&
            (version.nil? || record.version == version) &&
            record.status.to_s == "success"

          end

        end

      end

    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/history"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/executor"',
        'require_relative "lightek/upgrades/executor"\n' + require
    )

path.write_text(text)
PY


echo "Updating executor history integration..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/executor.rb")

text = path.read_text()

old = '''        Result.new(
          name: upgrade[:name],
          version: upgrade[:version],
          status: :success,
          message: "Upgrade executed"
        )
'''

new = '''        result =
          Result.new(
            name: upgrade[:name],
            version: upgrade[:version],
            status: :success,
            message: "Upgrade executed"
          )


        History.record(
          name: result.name,
          version: result.version,
          status: result.status,
          message: result.message
        )


        result
'''

if old in text:
    text = text.replace(old, new)

path.write_text(text)
PY


echo "Upgrade history complete."

echo
echo "Backup:"
echo "$BACKUP"