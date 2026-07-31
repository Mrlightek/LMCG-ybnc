#!/usr/bin/env bash

set -e

echo "Upgrading Lightek Doctor public API cleanup..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_public_api_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."

mkdir -p "$BACKUP"

cp -R lib/lightek "$BACKUP/" 2>/dev/null || true
cp bin/lightek "$BACKUP/" 2>/dev/null || true


echo "Normalizing Core loader..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek.rb")

text = path.read_text()

required = [
    'require_relative "lightek/contracts/issue"',
    'require_relative "lightek/contracts/validator"',
    'require_relative "lightek/contracts/analyzer"',
    'require_relative "lightek/contracts/ability_analyzer"',
    'require_relative "lightek/contracts/pipeline_analyzer"',
    'require_relative "lightek/contracts/contract_issue"',
    'require_relative "lightek/analyzers/schema_analyzer"',
    'require_relative "lightek/analyzers/route_analyzer"',
    'require_relative "lightek/analyzers/view_analyzer"',
    'require_relative "lightek/backup_manager"',
]

lines = []

for line in required:
    lines.append(line)

path.write_text("\n".join(lines) + "\n")
PY


echo "Cleaning duplicate ContractIssue loader..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/contracts/contract_issue.rb")

path.write_text(
'''require_relative "issue"
'''
)
PY


echo "Updating Doctor API..."

python3 <<'PY'
from pathlib import Path

path = Path("bin/lightek")

text = path.read_text()

text = text.replace(
'''validator =
  Lightek::Contracts::Validator
''',
'''validator =
  Lightek::Contracts::Validator
'''
)

path.write_text(text)
PY


echo "Public API cleanup complete."

echo
echo "Backup:"
echo "$BACKUP"
