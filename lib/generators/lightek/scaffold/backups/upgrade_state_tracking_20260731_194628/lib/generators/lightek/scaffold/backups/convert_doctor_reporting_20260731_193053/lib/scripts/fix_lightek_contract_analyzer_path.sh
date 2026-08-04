#!/bin/bash

set -e

echo "Fixing Lightek Contract Analyzer helper path..."

GENERATOR="lib/generators/lightek/scaffold"
HELPERS="lib/generators/lightek/helpers"

mkdir -p "$HELPERS"

python3 <<'PY'

from pathlib import Path

path = Path("upgrade_lightek_contract_analyzer.sh")

content = path.read_text()

content = content.replace(
'HELPERS="$GENERATOR/helpers"',
'HELPERS="lib/generators/lightek/helpers"'
)

path.write_text(content)

PY


echo "Path fixed."
echo ""
echo "Updated:"
echo "HELPERS=lib/generators/lightek/helpers"
echo ""
echo "Run again:"
echo "./upgrade_lightek_contract_analyzer.sh"