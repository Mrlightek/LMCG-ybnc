#!/bin/bash

set -e

echo "Switching Lightek Doctor to Core..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP="lib/generators/lightek/scaffold/backups/doctor_core_switch_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

cp bin/lightek "$BACKUP/lightek"

echo "Updating Doctor loader..."

python3 <<'PY'
from pathlib import Path

path = Path("bin/lightek")

text = path.read_text()

old = """
require_relative "../lib/generators/lightek/helpers/contract_validator"
require_relative "../lib/generators/lightek/helpers/contract_analyzer"
require_relative "../lib/generators/lightek/helpers/contract_issue"
require_relative "../lib/generators/lightek/helpers/view_analyzer"
require_relative "../lib/generators/lightek/helpers/route_analyzer"
"""

new = """
require_relative "../lib/lightek"
"""

text = text.replace(old, new)

text = text.replace(
    "Lightek::Generators::Helpers::ContractValidator",
    "Lightek::Contracts::Validator"
)

path.write_text(text)

PY


echo "Doctor Core switch complete."

echo
echo "Backup:"
echo "$BACKUP"