#!/usr/bin/env bash

set -e

echo "Upgrading Lightek Doctor reporting..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_reporting_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."
mkdir -p "$BACKUP"

cp -R lib/lightek "$BACKUP/" 2>/dev/null || true
cp bin/lightek "$BACKUP/" 2>/dev/null || true


echo "Creating reporting layer..."

mkdir -p lib/lightek/reporting


cat > lib/lightek/reporting/reporter.rb <<'RUBY'
module Lightek
  module Reporting

    class Reporter

      def report(result)
        raise NotImplementedError
      end

    end

  end
end
RUBY


cat > lib/lightek/reporting/console_reporter.rb <<'RUBY'
require_relative "reporter"

module Lightek
  module Reporting

    class ConsoleReporter < Reporter

      def report(result)

        puts
        puts "======================================"
        puts "Summary"
        puts "======================================"

        puts "Errors   : #{result[:errors]}"
        puts "Warnings : #{result[:warnings]}"

        puts

        if result[:errors].zero?
          puts "✓ Contract validation passed."
        else
          puts "✗ Contract validation failed."
        end

      end

    end

  end
end
RUBY


cat > lib/lightek/reporting/json_reporter.rb <<'RUBY'
require "json"
require_relative "reporter"

module Lightek
  module Reporting

    class JsonReporter < Reporter

      def report(result)

        puts JSON.pretty_generate(result)

      end

    end

  end
end
RUBY


cat > lib/lightek/reporting/ci_reporter.rb <<'RUBY'
require_relative "console_reporter"

module Lightek
  module Reporting

    class CiReporter < ConsoleReporter

      def report(result)

        super

        exit 1 unless result[:errors].zero?

      end

    end

  end
end
RUBY


echo "Updating Core loader..."

cat >> lib/lightek.rb <<'RUBY'

require_relative "lightek/reporting/reporter"
require_relative "lightek/reporting/console_reporter"
require_relative "lightek/reporting/json_reporter"
require_relative "lightek/reporting/ci_reporter"
RUBY


echo "Doctor reporting upgrade complete."

echo
echo "Backup:"
echo "$BACKUP"
