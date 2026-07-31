#!/bin/bash

set -e

echo "Completing Lightek Core dependency extraction..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP="lib/generators/lightek/scaffold/backups/core_dependency_$TIMESTAMP"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp -R lib/lightek "$BACKUP/lightek" || true


mkdir -p lib/lightek/analyzers


echo "Moving remaining analyzers..."

for file in ability_analyzer pipeline_analyzer contract_issue; do

  if [ -f "lib/generators/lightek/helpers/$file.rb" ]; then

    cp \
    "lib/generators/lightek/helpers/$file.rb" \
    "lib/lightek/contracts/$file.rb"

  fi

done


echo "Updating loader..."

cat >> lib/lightek.rb <<'RUBY'

require_relative "lightek/contracts/ability_analyzer"
require_relative "lightek/contracts/pipeline_analyzer"
require_relative "lightek/contracts/contract_issue"
RUBY


echo "Core dependency extraction complete."

echo "Backup:"
echo "$BACKUP"