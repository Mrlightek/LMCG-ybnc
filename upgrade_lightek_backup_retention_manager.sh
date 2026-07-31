#!/usr/bin/env bash
set -e

echo "Adding Lightek Backup Retention Manager..."

BACKUP="lib/generators/lightek/scaffold/backups/backup_retention_manager_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."
mkdir -p "$BACKUP"

cp -R lib/lightek "$BACKUP/" 2>/dev/null || true

mkdir -p lib/lightek/backup

cat > lib/lightek/backup/retention_manager.rb <<'RUBY'
require "fileutils"

module Lightek
  module Backup

    class RetentionManager

      DEFAULT_LIMIT = 10

      def initialize(
        directory = "lib/generators/lightek/scaffold/backups",
        limit = DEFAULT_LIMIT
      )

        @directory = directory
        @limit = limit

      end


      def cleanup

        backups =
          Dir.glob(
            File.join(@directory, "*")
          )
          .select do |path|

            File.directory?(path) &&
              File.basename(path) != "backups"

          end
          .sort


        excess =
          backups[0...-@limit] || []


        excess.each do |backup|

          FileUtils.rm_rf(backup)

        end


        excess

      end


    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require_line = 'require_relative "lightek/backup/retention_manager"'

if require_line not in text:
    text += "\n" + require_line + "\n"

path.write_text(text)
PY


echo "Backup retention manager complete."

echo
echo "Backup:"
echo "$BACKUP"
