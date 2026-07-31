#!/usr/bin/env bash

set -e

echo "Upgrading Lightek Upgrade Registry..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_registry_v2_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating upgrade registry discovery..."


mkdir -p lib/lightek/upgrades/manifests


cat > lib/lightek/upgrades/registry.rb <<'RUBY'
module Lightek
  module Upgrades

    class Registry

      @upgrades = []

      class << self

        attr_reader :upgrades


        def register(attributes)

          @upgrades << attributes

        end


        def all

          load_manifests

          @upgrades

        end


        private


        def load_manifests

          return if @loaded

          Dir[
            File.expand_path(
              "manifests/*.rb",
              __dir__
            )
          ].sort.each do |file|

            require file

          end

          @loaded = true

        end

      end

    end

  end
end
RUBY


cat > lib/lightek/upgrades/manifests/doctor_reporting.rb <<'RUBY'
Lightek::Upgrades::Registry.register(
  name: "doctor_reporting",
  version: "1.0.0"
)
RUBY


cat > lib/lightek/upgrades/manifests/doctor_issue_serialization.rb <<'RUBY'
Lightek::Upgrades::Registry.register(
  name: "doctor_issue_serialization",
  version: "1.0.0"
)
RUBY


cat > lib/lightek/upgrades/manifests/backup_manager_hardening.rb <<'RUBY'
Lightek::Upgrades::Registry.register(
  name: "backup_manager_hardening",
  version: "1.0.0"
)
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/registry"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/cli"',
        'require_relative "lightek/upgrades/registry"\nrequire_relative "lightek/upgrades/cli"'
    )

path.write_text(text)

PY


echo "Upgrade Registry v2 complete."

echo
echo "Backup:"
echo "$BACKUP"