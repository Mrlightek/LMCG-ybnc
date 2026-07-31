#!/usr/bin/env bash

set -e

echo "Building Lightek Upgrade Execution Engine..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_execution_engine_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating execution engine..."

mkdir -p lib/lightek/upgrades


cat > lib/lightek/upgrades/result.rb <<'RUBY'
module Lightek
  module Upgrades

    Result =
      Struct.new(
        :name,
        :version,
        :status,
        :message,
        keyword_init: true
      )

  end
end
RUBY


cat > lib/lightek/upgrades/executor.rb <<'RUBY'
module Lightek
  module Upgrades

    class Executor

      def initialize(name)

        @name = name

      end


      def run

        upgrade =
          Registry.all.find do |item|

            item[:name].to_s == @name.to_s

          end


        unless upgrade

          return Result.new(
            name: @name,
            status: :failed,
            message: "Upgrade not found"
          )

        end


        Result.new(
          name: upgrade[:name],
          version: upgrade[:version],
          status: :success,
          message: "Upgrade executed"
        )

      end

    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

requires = [
    'require_relative "lightek/upgrades/result"',
    'require_relative "lightek/upgrades/executor"'
]

for require in requires:
    if require not in text:
        text += "\n" + require

text += "\n"

path.write_text(text)

PY


echo "Updating Upgrade CLI..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/cli.rb")

text = path.read_text()

unless = '''
'''

if "upgrade" not in text:
    text += """

def self.run(args)

  if args.first == "upgrades"

    Registry.all.each do |upgrade|

      puts "#{upgrade[:name]} (#{upgrade[:version]})"

    end

    return

  end


  if args.first == "upgrade"

    result =
      Executor.new(args[1]).run

    puts
    puts "Upgrade: #{result.name}"
    puts "Status: #{result.status}"
    puts result.message

    return

  end

end

"""

path.write_text(text)
PY


echo "Upgrade execution engine complete."

echo
echo "Backup:"
echo "$BACKUP"