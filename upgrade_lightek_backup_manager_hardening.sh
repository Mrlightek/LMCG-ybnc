#!/usr/bin/env bash
set -e

echo "Hardening Lightek Backup Manager..."

BACKUP="lib/generators/lightek/scaffold/backups/backup_manager_hardening_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."
mkdir -p "$BACKUP"

cp -R lib/lightek/backup_manager.rb "$BACKUP/" 2>/dev/null || true
cp -R lib/lightek.rb "$BACKUP/" 2>/dev/null || true

mkdir -p lib/lightek/backup

cat > lib/lightek/backup/manifest.rb <<'RUBY'
module Lightek
  module Backup

    class Manifest

      attr_reader :files

      def initialize(files = [])
        @files = files
      end

      def add(file)
        files << file
      end

      def to_h
        {
          files: files
        }
      end

    end

  end
end
RUBY

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/backup_manager.rb")

if path.exists():
    text = path.read_text()

    if 'require_relative "backup/manifest"' not in text:
        text = 'require_relative "backup/manifest"\n\n' + text

    path.write_text(text)
PY

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

if 'require_relative "lightek/backup/manifest"' not in text:
    text = text.replace(
        'require_relative "lightek/backup_manager"',
        'require_relative "lightek/backup_manager"\nrequire_relative "lightek/backup/manifest"'
    )

path.write_text(text)
PY

echo "Backup Manager hardening complete."

echo
echo "Backup:"
echo "$BACKUP"
