#!/usr/bin/env bash

set -e

echo "Adding Lightek Upgrade Manifest Loader..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_manifest_loader_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating manifest loader..."

mkdir -p lib/lightek/upgrades


cat > lib/lightek/upgrades/loader.rb <<'RUBY'
module Lightek
  module Upgrades

    class Loader

      def self.load_manifests

        manifest_path =
          File.expand_path(
            "manifests/*.rb",
            __dir__
          )


        Dir[manifest_path].each do |file|

          require file

        end

      end


      def self.load_handlers

        handler_path =
          File.expand_path(
            "handlers/*.rb",
            __dir__
          )


        Dir[handler_path].each do |file|

          require file

        end

      end


      def self.load!

        load_handlers
        load_manifests

      end

    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/loader"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/handler"',
        'require_relative "lightek/upgrades/handler"\n' + require
    )

# remove hardcoded handler loading
text = text.replace(
    'require_relative "lightek/upgrades/handlers/doctor_reporting"',
    ''
)

text += "\nLightek::Upgrades::Loader.load!\n"

path.write_text(text)

PY


echo "Updating upgrade registry..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/registry.rb")

if path.exists():

    text = path.read_text()

    if "def self.register" not in text:

        text += """

module Lightek
  module Upgrades

    class Registry

      def self.register(attributes)

        @upgrades ||= []

        @upgrades << attributes

      end

    end

  end
end

"""

    path.write_text(text)

PY


echo "Upgrade manifest loader complete."

echo
echo "Backup:"
echo "$BACKUP"