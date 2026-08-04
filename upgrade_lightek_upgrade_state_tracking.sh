#!/usr/bin/env bash

set -e

echo "Adding Lightek Upgrade State Tracking..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_state_tracking_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating upgrade state store..."

mkdir -p lib/lightek/upgrades


cat > lib/lightek/upgrades/state.rb <<'RUBY'
module Lightek
  module Upgrades

    class State

      FILE =
        File.expand_path(
          "upgrade_state.yml",
          Dir.pwd
        )


      def self.applied

        return {} unless File.exist?(FILE)

        YAML.load_file(FILE) || {}

      end


      def self.applied?(name, version)

        applied[name] == version.to_s

      end


      def self.record(name, version)

        data = applied

        data[name] = version.to_s

        File.write(
          FILE,
          data.to_yaml
        )

      end

    end

  end
end
RUBY


echo "Updating executor state handling..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/executor.rb")

text = path.read_text()

if 'require_relative "state"' not in text:
    text = 'require_relative "state"\n' + text


old = '''
        if upgrade[:handler]

          applied =
            upgrade[:handler].apply

          unless applied

            raise "Upgrade handler failed"

          end

        end
'''


new = '''
        if State.applied?(
          upgrade[:name],
          upgrade[:version]
        )

          return Result.new(
            name: upgrade[:name],
            version: upgrade[:version],
            status: :skipped,
            message: "Already applied"
          )

        end


        if upgrade[:handler]

          applied =
            upgrade[:handler].apply

          unless applied

            raise "Upgrade handler failed"

          end

        end


        State.record(
          upgrade[:name],
          upgrade[:version]
        )
'''

if old in text:
    text = text.replace(old, new)

path.write_text(text)

PY


echo "Updating loader..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/state"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/loader"',
        'require_relative "lightek/upgrades/loader"\n' + require
    )

path.write_text(text)

PY


echo "Upgrade state tracking complete."

echo
echo "Backup:"
echo "$BACKUP"