#!/usr/bin/env bash

set -e

echo "Upgrading Lightek Doctor CLI reporting switch..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_cli_switch_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."
mkdir -p "$BACKUP"

cp bin/lightek "$BACKUP/"


echo "Updating Doctor CLI..."

python3 <<'PY'
from pathlib import Path

path = Path("bin/lightek")

text = path.read_text()

text = text.replace(
'''puts
puts "======================================"
puts "Summary"
puts "======================================"

puts "Errors   : #{errors}"
puts "Warnings : #{warnings}"

puts

if errors.zero?

  puts "✓ Contract validation passed."

else

  puts "✗ Contract validation failed."

  exit 1

end
''',
'''result = {
  errors: errors,
  warnings: warnings
}

reporter =
  case ARGV.first

  when "--json"
    Lightek::Reporting::JsonReporter.new

  when "--ci"
    Lightek::Reporting::CiReporter.new

  else
    Lightek::Reporting::ConsoleReporter.new

  end

reporter.report(result)

exit 1 unless errors.zero?
'''
)

path.write_text(text)
PY


echo "Doctor CLI switch complete."

echo
echo "Backup:"
echo "$BACKUP"
