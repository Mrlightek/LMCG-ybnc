#!/usr/bin/env bash

set -e

echo "Integrating Lightek Doctor with generators..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_generator_integration_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."

mkdir -p "$BACKUP"

cp -R lib/generators/lightek "$BACKUP/" 2>/dev/null || true


echo "Adding Doctor runner..."

mkdir -p lib/lightek/generators


cat > lib/lightek/generators/doctor_runner.rb <<'RUBY'
module Lightek
  module Generators
    module DoctorRunner

      def run_doctor

        return unless File.exist?(
          File.expand_path(
            "../../../bin/lightek",
            __dir__
          )
        )

        puts
        puts "Running Lightek Doctor..."
        puts

        system(
          "bin/lightek"
        )

      end

    end
  end
end
RUBY


echo "Updating scaffold generator hooks..."

GENERATOR="lib/generators/lightek/scaffold/scaffold_generator.rb"


if [ -f "$GENERATOR" ]; then

python3 <<PY
from pathlib import Path

path = Path("$GENERATOR")

text = path.read_text()

unless = '''
require_relative "../../../lightek/generators/doctor_runner"
'''

if 'doctor_runner' not in text:
    text = unless + "\\n" + text


unless_method = '''
include Lightek::Generators::DoctorRunner
'''

if 'include Lightek::Generators::DoctorRunner' not in text:
    text = text.replace(
        "class ScaffoldGenerator",
        "class ScaffoldGenerator\\n\\n  include Lightek::Generators::DoctorRunner"
    )

if "run_doctor" not in text:
    text += "\\n\\nrun_doctor\\n"

path.write_text(text)
PY

fi


echo "Creating generator Doctor command..."

mkdir -p lib/generators/lightek/doctor


cat > lib/generators/lightek/doctor_generator.rb <<'RUBY'
require "rails/generators"

module Lightek
  module Generators

    class DoctorGenerator < Rails::Generators::Base

      source_root File.expand_path(
        "templates",
        __dir__
      )

      def run

        system(
          "bin/lightek"
        )

      end

    end

  end
end
RUBY


echo "Doctor generator integration complete."

echo
echo "Backup:"
echo "$BACKUP"
