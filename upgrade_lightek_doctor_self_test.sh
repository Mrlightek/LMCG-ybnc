#!/usr/bin/env bash

set -e

echo "Adding Lightek Doctor self test..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_self_test_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."

mkdir -p "$BACKUP"

cp bin/lightek "$BACKUP/" 2>/dev/null || true


echo "Creating self test contract..."

mkdir -p tmp/lightek_doctor_self_test


cat > tmp/lightek_doctor_self_test/run.rb <<'RUBY'
require_relative "../../config/environment"
require_relative "../../lib/lightek"

puts
puts "======================================"
puts " Lightek Doctor Self Test"
puts "======================================"
puts

validator =
  Lightek::Contracts::Validator

failures = 0


class FakeModel

  def self.name
    "BrokenExample"
  end

  def self.column_names
    ["id", "slug"]
  end

end


doctor =
  validator.new(FakeModel.name)


doctor.validate


issues =
  doctor.issues


if issues.empty?

  puts "ERROR: Doctor did not detect expected issues."
  failures += 1

else

  puts "✓ Doctor detected issues."

  issues.each do |issue|

    puts
    puts "[#{issue.level}] #{issue.message}"

  end

end


puts

if failures.zero?

  puts "✓ Self test passed."

else

  puts "✗ Self test failed."
  exit 1

end
RUBY


echo "Self test created."

echo
echo "Backup:"
echo "$BACKUP"
