#!/usr/bin/env bash

set -e

echo "Moving Lightek metadata into managed store..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/metadata_store_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating .lightek metadata directory..."

mkdir -p .lightek


if [ -f upgrade_state.yml ]; then
  mv upgrade_state.yml .lightek/upgrades.yml
fi


cat > lib/lightek/upgrades/metadata.rb <<'RUBY'
module Lightek
  module Upgrades

    class Metadata

      ROOT =
        File.expand_path(
          ".lightek",
          Dir.pwd
        )


      def self.ensure!

        Dir.mkdir(ROOT) unless Dir.exist?(ROOT)

      end


      def self.file(name)

        ensure!

        File.join(
          ROOT,
          name
        )

      end

    end

  end
end
RUBY


echo "Updating state storage..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/state.rb")

text = path.read_text()

text = text.replace(
'''
      FILE =
        File.expand_path(
          "upgrade_state.yml",
          Dir.pwd
        )
''',
'''
      FILE =
        Metadata.file(
          "upgrades.yml"
        )
'''
)

if 'require_relative "metadata"' not in text:
    text = 'require_relative "metadata"\n' + text

path.write_text(text)

PY


echo "Updating metadata loading..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/metadata"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/state"',
        'require_relative "lightek/upgrades/state"\n' + require
    )

path.write_text(text)

PY


echo "Metadata store migration complete."

echo
echo "Backup:"
echo "$BACKUP"