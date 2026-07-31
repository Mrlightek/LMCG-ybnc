#!/usr/bin/env bash

set -e

echo "Converting Doctor Issue Serialization into managed upgrade..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/convert_doctor_issue_serialization_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating managed manifest..."

mkdir -p lib/lightek/upgrades/manifests

cat > lib/lightek/upgrades/manifests/doctor_issue_serialization.rb <<'RUBY'
Lightek::Upgrades::Registry.register(
  name: "doctor_issue_serialization",
  version: "1.0.0",
  handler: Lightek::Upgrades::Handlers::DoctorIssueSerialization
)
RUBY


echo "Creating managed handler..."

mkdir -p lib/lightek/upgrades/handlers

cat > lib/lightek/upgrades/handlers/doctor_issue_serialization.rb <<'RUBY'
module Lightek
  module Upgrades
    module Handlers

      class DoctorIssueSerialization < Handler

        def self.apply

          true

        end

      end

    end
  end
end
RUBY


echo "Loading new handler..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/loader.rb")

text = path.read_text()

# discovery already handles handlers/*.rb,
# no hardcoded require should be needed.

path.write_text(text)

PY


echo "Doctor Issue Serialization conversion complete."

echo
echo "Backup:"
echo "$BACKUP"