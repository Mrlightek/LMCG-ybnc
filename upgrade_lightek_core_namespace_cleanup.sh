#!/bin/bash

set -e

echo "Upgrading Lightek Core namespaces..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP="lib/generators/lightek/scaffold/backups/core_namespace_$TIMESTAMP"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp -R lib/lightek "$BACKUP/lightek"


python3 <<'PY'
from pathlib import Path

replacements = {

    "module Lightek\n  module Generators\n    module Helpers": 
    "module Lightek\n  module Contracts",

    "class ContractValidator":
    "class Validator",

    "class ContractIssue":
    "class Issue",

}


files = list(Path("lib/lightek").rglob("*.rb"))

for path in files:

    text = path.read_text()

    original = text

    for old,new in replacements.items():
        text = text.replace(old,new)

    if text != original:
        path.write_text(text)

PY


echo "Updating Core loader..."

cat lib/lightek.rb

echo
echo "Core namespace cleanup complete."

echo
echo "Backup:"
echo "$BACKUP"