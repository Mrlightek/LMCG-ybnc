#!/bin/bash

set -e

echo "Upgrading Lightek Core extraction..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP="lib/generators/lightek/scaffold/backups/core_extraction_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

cp -R lib/generators/lightek/helpers "$BACKUP/helpers" || true


echo "Creating Lightek core structure..."

mkdir -p lib/lightek/contracts
mkdir -p lib/lightek/analyzers


echo "Moving contract classes..."

cp lib/generators/lightek/helpers/contract_validator.rb \
   lib/lightek/contracts/validator.rb

cp lib/generators/lightek/helpers/contract_issue.rb \
   lib/lightek/contracts/issue.rb

cp lib/generators/lightek/helpers/contract_analyzer.rb \
   lib/lightek/contracts/analyzer.rb


echo "Moving analyzers..."

cp lib/generators/lightek/helpers/schema_analyzer.rb \
   lib/lightek/analyzers/schema_analyzer.rb 2>/dev/null || true

cp lib/generators/lightek/helpers/route_analyzer.rb \
   lib/lightek/analyzers/route_analyzer.rb 2>/dev/null || true

cp lib/generators/lightek/helpers/view_analyzer.rb \
   lib/lightek/analyzers/view_analyzer.rb 2>/dev/null || true


echo "Moving backup manager..."

cp lib/generators/lightek/helpers/backup_manager.rb \
   lib/lightek/backup_manager.rb 2>/dev/null || true


echo "Creating Lightek loader..."

cat > lib/lightek.rb <<'RUBY'
require_relative "lightek/contracts/validator"
require_relative "lightek/contracts/issue"
require_relative "lightek/contracts/analyzer"

require_relative "lightek/analyzers/schema_analyzer"
require_relative "lightek/analyzers/route_analyzer"
require_relative "lightek/analyzers/view_analyzer"

require_relative "lightek/backup_manager"
RUBY


echo "Creating compatibility layer..."

mkdir -p lib/generators/lightek/helpers/legacy


cat > lib/generators/lightek/helpers/legacy_loader.rb <<'RUBY'
require "lightek"

module Lightek
  module Generators
    module Helpers

      ContractValidator =
        ::Lightek::Contracts::Validator unless const_defined?(:ContractValidator)

    end
  end
end
RUBY


echo "Core extraction complete."

echo ""
echo "Backup:"
echo "$BACKUP"