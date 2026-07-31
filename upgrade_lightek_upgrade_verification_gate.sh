#!/usr/bin/env bash

set -e

echo "Adding Lightek Upgrade Verification Gate..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP="lib/generators/lightek/scaffold/backups/upgrade_verification_gate_${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "lib/generators/lightek/scaffold/backups" \
  --exclude "tmp" \
  --exclude "log" \
  lib/ "$BACKUP/lib/"


echo "Creating verifier..."

cat > lib/lightek/upgrades/verifier.rb <<'RUBY'
module Lightek
  module Upgrades

    class Verifier

      def self.verify

        validator =
          Lightek::Contracts::Validator


        errors = 0


        ApplicationRecord.descendants
          .reject(&:abstract_class?)
          .each do |model|

            doctor =
              validator.new(model.name)

            doctor.validate

            issues =
              doctor.instance_variable_get(:@issues)


            errors +=
              issues.count do |issue|

                issue.level == :error

              end

          end


        errors.zero?

      rescue => e

        false

      end

    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require = 'require_relative "lightek/upgrades/verifier"'

if require not in text:
    text = text.replace(
        'require_relative "lightek/upgrades/history"',
        'require_relative "lightek/upgrades/history"\n' + require
    )

path.write_text(text)
PY


echo "Updating executor verification flow..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/upgrades/executor.rb")

text = path.read_text()

old = '''        History.record(
          name: result.name,
          version: result.version,
          status: result.status,
          message: result.message
        )


        result
'''

new = '''        verified =
          Verifier.verify


        if verified

          result.status = :success
          result.message = "Upgrade executed and verified"

        else

          result.status = :failed
          result.message = "Upgrade executed but verification failed"

        end


        History.record(
          name: result.name,
          version: result.version,
          status: result.status,
          message: result.message
        )


        result
'''

if old in text:
    text = text.replace(old, new)

path.write_text(text)
PY


echo "Upgrade verification gate complete."

echo
echo "Backup:"
echo "$BACKUP"