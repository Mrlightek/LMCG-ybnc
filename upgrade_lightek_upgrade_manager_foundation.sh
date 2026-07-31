#!/usr/bin/env bash

set -e

echo "Building Lightek Upgrade Manager Foundation..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_manager_foundation_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating upgrade infrastructure..."

mkdir -p lib/lightek/upgrades


cat > lib/lightek/upgrades/upgrade.rb <<'RUBY'
module Lightek
  module Upgrades

    class Upgrade

      attr_reader :name, :version

      def initialize(name:, version:)
        @name = name
        @version = version
      end

    end

  end
end
RUBY


cat > lib/lightek/upgrades/registry.rb <<'RUBY'
module Lightek
  module Upgrades

    class Registry

      def self.all

        [
          {
            name: "doctor_reporting",
            version: "1.0.0"
          },
          {
            name: "doctor_issue_serialization",
            version: "1.0.0"
          },
          {
            name: "backup_manager_hardening",
            version: "1.0.0"
          }
        ]

      end

    end

  end
end
RUBY


cat > lib/lightek/upgrades/manifest.rb <<'RUBY'
require "json"

module Lightek
  module Upgrades

    class Manifest

      PATH =
        "tmp/lightek_upgrades.json"


      def self.write(data)

        FileUtils.mkdir_p(
          File.dirname(PATH)
        )

        File.write(
          PATH,
          JSON.pretty_generate(data)
        )

      end


      def self.read

        return [] unless File.exist?(PATH)

        JSON.parse(
          File.read(PATH)
        )

      end

    end

  end
end
RUBY


cat > lib/lightek/upgrades/manager.rb <<'RUBY'
module Lightek
  module Upgrades

    class Manager


      def self.list

        Registry.all

      end


    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

requires = '''
require_relative "lightek/upgrades/upgrade"
require_relative "lightek/upgrades/registry"
require_relative "lightek/upgrades/manifest"
require_relative "lightek/upgrades/manager"
'''

if "lightek/upgrades/manager" not in text:
    text += requires

path.write_text(text)

PY


echo "Upgrade Manager foundation complete."

echo
echo "Backup:"
echo "$BACKUP"