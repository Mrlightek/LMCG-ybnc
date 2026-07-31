#!/bin/bash

set -e

echo "Fixing Lightek backup architecture..."

OLD="lib/generators/lightek/scaffold/backups"
NEW=".lightek/backups"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Creating new backup storage..."

mkdir -p "$NEW"


if [ -d "$OLD" ]; then

  echo "Moving existing backups..."

  mkdir -p "$NEW/migrated_$TIMESTAMP"

  cp -R "$OLD/" "$NEW/migrated_$TIMESTAMP/"

  echo "Removing recursive backup tree..."

  rm -rf "$OLD"

else

  echo "No old backup directory found."

fi


echo "Updating BackupManager..."


cat > lib/generators/lightek/helpers/backup_manager.rb <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class BackupManager

        BACKUP_ROOT =
          Rails.root.join(
            ".lightek",
            "backups"
          )


        KEEP = 25



        def self.create(name)

          timestamp =
            Time.now.strftime(
              "%Y%m%d_%H%M%S"
            )


          path =
            BACKUP_ROOT.join(
              "#{name}_#{timestamp}"
            )


          FileUtils.mkdir_p(path)


          path

        end



        def self.prune

          return unless Dir.exist?(BACKUP_ROOT)


          backups =
            Dir[
              BACKUP_ROOT.join("*")
            ]
            .sort


          backups
            .take(
              backups.length - KEEP
            )
            .each do |old|

              FileUtils.rm_rf(old)

            end


        end


      end

    end
  end
end
RUBY


echo "Cleaning Bootsnap cache..."

rm -rf tmp/cache


echo
echo "Backup architecture fixed."
echo
echo "New backup location:"
echo "$NEW"