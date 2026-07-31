#!/usr/bin/env bash

set -e

echo "Adding Lightek Upgrade Handler System..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_handler_system_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating handler infrastructure..."

mkdir -p lib/lightek/upgrades/handlers


cat > lib/lightek/upgrades/handler.rb <<'RUBY'
module Lightek
  module Upgrades

    class Handler

      def self.apply

        raise NotImplementedError,
          "Upgrade handler must implement apply"

      end

    end

  end
end
RUBY


cat > lib/lightek/upgrades/handlers/doctor_reporting.rb <<'RUBY'
module Lightek
  module Upgrades
    module Handlers

      class DoctorReporting < Handler

        def self.apply

          true

        end

      end

    end
  end
end
RUBY


python3 <<'PY'
from pathlib import Path

registry = Path("lib/lightek/upgrades/registry.rb")

text = registry.read_text()

text = text.replace(
    'attr_reader :upgrades',
    'attr_reader :upgrades'
)

registry.write_text(text)


manifest = Path(
    "lib/lightek/upgrades/manifests/doctor_reporting.rb"
)

manifest.write_text(
'''Lightek::Upgrades::Registry.register(
  name: "doctor_reporting",
  version: "1.0.0",
  handler: Lightek::Upgrades::Handlers::DoctorReporting
)
'''
)


loader = Path("lib/lightek.rb")

text = loader.read_text()

require = 'require_relative "lightek/upgrades/handler"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/executor"',
        'require_relative "lightek/upgrades/executor"\n' + require
    )

handler_require = 'require_relative "lightek/upgrades/handlers/doctor_reporting"'

if handler_require not in text:
    text += "\n" + handler_require + "\n"

loader.write_text(text)

PY


echo "Updating executor handler execution..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/executor.rb")

text = path.read_text()

old = '''        result =
          Result.new(
            name: upgrade[:name],
            version: upgrade[:version],
            status: :success,
            message: "Upgrade executed"
          )
'''

new = '''        if upgrade[:handler]

          upgrade[:handler].apply

        end


        result =
          Result.new(
            name: upgrade[:name],
            version: upgrade[:version],
            status: :success,
            message: "Upgrade handler executed"
          )
'''

if old in text:
    text = text.replace(old, new)

path.write_text(text)

PY


echo "Upgrade handler system complete."

echo
echo "Backup:"
echo "$BACKUP"