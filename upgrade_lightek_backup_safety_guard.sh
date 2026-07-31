#!/usr/bin/env bash

set -e

echo "Adding Lightek Backup Safety Guard..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/backup_safety_guard_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Hardening Backup Manager..."

mkdir -p lib/lightek/backup


cat > lib/lightek/backup/safety_guard.rb <<'RUBY'
module Lightek
  module Backup

    class SafetyGuard

      def self.safe_path?(path)

        normalized =
          File.expand_path(path)

        blocked =
          [
            "/backups/",
            "/tmp/",
            "/log/"
          ]

        blocked.none? do |entry|

          normalized.include?(entry)

        end

      end


      def self.validate!(path)

        unless safe_path?(path)

          raise(
            "Unsafe backup path detected: #{path}"
          )

        end

        true

      end

    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/backup/safety_guard"'

if require not in text:
    text += "\n" + require + "\n"

path.write_text(text)
PY


echo "Backup safety guard complete."

echo
echo "Backup:"
echo "$BACKUP"