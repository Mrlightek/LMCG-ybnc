#!/bin/bash

set -e

echo "Creating Lightek Doctor..."

mkdir -p bin

cat > bin/lightek <<'RUBY'
#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= "development"

require_relative "../config/environment"

puts
puts "======================================"
puts "       Lightek Doctor"
puts "======================================"
puts

validator =
  Lightek::Generators::Helpers::ContractValidator

errors = 0
warnings = 0

ApplicationRecord.descendants
  .reject(&:abstract_class?)
  .sort_by(&:name)
  .each do |model|

    puts "Inspecting #{model.name}..."

    begin

      doctor =
        validator.new(model.name)

      doctor.validate

      issues =
        doctor.instance_variable_get(:@issues)

      issues.each do |issue|

        case issue.level

        when :error
          errors += 1

        when :warning
          warnings += 1

        end

      end

    rescue => e

      errors += 1

      puts
      puts "[ERROR]"
      puts "#{model.name}"
      puts e.message
      puts

    end

    puts

  end

puts
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
RUBY

chmod +x bin/lightek

echo
echo "Lightek Doctor created."
echo
echo "Run:"
echo
echo "bin/lightek"