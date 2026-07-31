#!/bin/bash

set -e

FILE="lib/generators/lightek/scaffold/scaffold_generator.rb"

echo "Fixing Lightek generator quote syntax..."

cp "$FILE" "${FILE}.before_quote_fix"

python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/scaffold/scaffold_generator.rb")

content = path.read_text()

content = content.replace(
    '""Example #{attribute.name}""',
    '"Example #{attribute.name}"'
)

content = content.replace(
    '""Example text for #{attribute.name}""',
    '"Example text for #{attribute.name}"'
)

path.write_text(content)
PY

echo "Quote syntax fixed."
echo "Backup:"
echo "${FILE}.before_quote_fix"