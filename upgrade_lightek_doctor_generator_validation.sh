#!/usr/bin/env bash
set -e

echo "Adding Lightek Doctor generator validation..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_generator_validation_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."
mkdir -p "$BACKUP"

cp -R lib/generators/lightek "$BACKUP/" 2>/dev/null || true


mkdir -p lib/lightek/testing


cat > lib/lightek/testing/generator_validation.rb <<'RUBY'
module Lightek
  module Testing

    class GeneratorValidation

      attr_reader :results


      def initialize

        @results = []

      end


      def check(path)

        unless File.exist?(path)

          @results << {
            level: :error,
            message: "Generated artifact missing: #{path}"
          }

          return false

        end


        @results << {
          level: :success,
          message: "Generated artifact exists: #{path}"
        }

        true

      end


      def passed?

        @results.none? do |result|

          result[:level] == :error

        end

      end


    end

  end
end
RUBY


python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

require_line = 'require_relative "lightek/testing/generator_validation"'

if require_line not in text:
    text += "\n" + require_line + "\n"

path.write_text(text)
PY


echo "Doctor generator validation complete."

echo
echo "Backup:"
echo "$BACKUP"
