#!/usr/bin/env bash

set -e

echo "Adding Lightek Upgrade Manager CLI..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_manager_cli_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating CLI layer..."

mkdir -p lib/lightek/upgrades


cat > lib/lightek/upgrades/cli.rb <<'RUBY'
module Lightek
  module Upgrades

    class CLI

      def self.run(arguments)

        command = arguments.shift

        case command

        when "upgrades"

          list

        when "upgrade"

          name = arguments.shift

          unless name
            puts "Missing upgrade name."
            exit 1
          end

          puts "Upgrade execution coming next:"
          puts name

        else

          puts <<~HELP

            Lightek Upgrade Commands

            bin/lightek upgrades

            bin/lightek upgrade NAME

          HELP

        end

      end


      def self.list

        puts
        puts "======================================"
        puts " Available Lightek Upgrades"
        puts "======================================"
        puts

        Registry.all.each do |upgrade|

          puts "#{upgrade[:name]} (#{upgrade[:version]})"

        end

        puts

      end

    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/cli"'

if require not in text:
    text += "\n#{require}\n"

path.write_text(text)

PY


python3 <<'PY'
from pathlib import Path

path = Path("bin/lightek")

text = path.read_text()

needle = 'require_relative "../lib/lightek"'

if 'lightek/upgrades/cli' not in text:
    text = text.replace(
        needle,
        needle + '\n'
    )

marker = 'puts\nputs "======================================"'

if 'Lightek::Upgrades::CLI.run' not in text:

    insertion = '''
if ARGV.any?

  Lightek::Upgrades::CLI.run(ARGV)

  exit

end

'''

    text = text.replace(marker, insertion + marker)

path.write_text(text)

PY


echo "Upgrade Manager CLI complete."

echo
echo "Backup:"
echo "$BACKUP"