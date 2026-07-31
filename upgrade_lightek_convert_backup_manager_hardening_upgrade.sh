#!/usr/bin/env bash

set -e

echo "Converting Backup Manager Hardening into managed upgrade..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/convert_backup_manager_hardening_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating managed manifest..."

mkdir -p lib/lightek/upgrades/manifests

cat > lib/lightek/upgrades/manifests/backup_manager_hardening.rb <<'RUBY'
Lightek::Upgrades::Registry.register(
  name: "backup_manager_hardening",
  version: "1.0.0",
  handler: Lightek::Upgrades::Handlers::BackupManagerHardening
)
RUBY


echo "Creating managed handler..."

mkdir -p lib/lightek/upgrades/handlers

cat > lib/lightek/upgrades/handlers/backup_manager_hardening.rb <<'RUBY'
module Lightek
  module Upgrades
    module Handlers

      class BackupManagerHardening < Handler

        def self.apply

          true

        end

      end

    end
  end
end
RUBY


echo "Backup Manager Hardening conversion complete."

echo
echo "Backup:"
echo "$BACKUP"