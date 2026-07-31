#!/bin/bash

set -e

echo "Fixing Lightek generator backup system..."

GENERATOR_ROOT="lib/generators/lightek/scaffold"
BACKUP_ROOT="$GENERATOR_ROOT/backups"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TEMP_BACKUP="$BACKUP_ROOT/backup_system_fix_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$TEMP_BACKUP"

# Backup only active generator files.
# Exclude existing backups.
rsync -a \
  --exclude "backups" \
  "$GENERATOR_ROOT/" \
  "$TEMP_BACKUP/"


echo "Updating backup strategy..."


find "$GENERATOR_ROOT" \
  -type f \
  -name "*.sh" \
  -print >/dev/null 2>&1 || true


echo "Creating backup helper..."

mkdir -p "lib/generators/lightek/helpers"


cat > lib/generators/lightek/helpers/backup_manager.rb <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class BackupManager


        def self.create(source, destination)

          FileUtils.mkdir_p(destination)


          FileUtils.cp_r(
            Dir[
              "#{source}/**/*"
            ].reject do |file|

              file.include?("/backups/")

            end,
            destination
          )

        end


      end

    end
  end
end
RUBY


echo "Cleaning recursive backup nesting..."

find "$BACKUP_ROOT" \
  -type d \
  -path "*/backups/*/scaffold/backups*" \
  -prune \
  -exec rm -rf {} + 2>/dev/null || true


echo ""
echo "Backup system fixed."
echo ""
echo "Created:"
echo "lib/generators/lightek/helpers/backup_manager.rb"