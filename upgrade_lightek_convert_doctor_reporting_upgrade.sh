#!/usr/bin/env bash

set -e

echo "Converting Doctor Reporting into managed upgrade..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/convert_doctor_reporting_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating managed manifest..."

mkdir -p lib/lightek/upgrades/manifests


cat > lib/lightek/upgrades/manifests/doctor_reporting.rb <<'RUBY'
Lightek::Upgrades::Registry.register(
  name: "doctor_reporting",
  version: "1.0.0",
  handler: Lightek::Upgrades::Handlers::DoctorReporting
)
RUBY


echo "Creating managed handler..."

mkdir -p lib/lightek/upgrades/handlers


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


echo "Updating executor to call handlers..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/executor.rb")

text = path.read_text()

old = '''
        if upgrade[:handler]

          upgrade[:handler].apply

        end
'''

new = '''
        if upgrade[:handler]

          applied =
            upgrade[:handler].apply

          unless applied

            raise "Upgrade handler failed"

          end

        end
'''

if old in text:
    text = text.replace(old, new)

path.write_text(text)
PY


echo "Doctor Reporting conversion complete."

echo
echo "Backup:"
echo "$BACKUP"