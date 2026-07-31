#!/bin/bash

set -e

echo "Fixing upgrade_ybnc_to_lightek_contract.sh..."

SCRIPT="upgrade_ybnc_to_lightek_contract.sh"

if [ ! -f "$SCRIPT" ]; then
  echo "Error: $SCRIPT not found"
  exit 1
fi


python3 <<'PY'
from pathlib import Path

path = Path("upgrade_ybnc_to_lightek_contract.sh")

content = path.read_text()


# Replace unsupported bash capitalization syntax
content = content.replace(
    '${ACTION^}',
    '${ACTION_CLASS}'
)


# Add action class helper after action loop
old = """for ACTION in create update destroy
  do

    JOB="""

new = """for ACTION in create update destroy
  do

    ACTION_CLASS=$(echo "$ACTION" | sed 's/./\\u&/')

    JOB="""

content = content.replace(old, new)


# Add model backup before modifying
old = """# Add callbacks if missing
  if ! grep -q "trigger_create_job" "$MODEL"; then"""

new = """# Backup model before modification
  cp "$MODEL" "$MODEL.backup"

  # Add callbacks if missing
  if ! grep -q "trigger_create_job" "$MODEL"; then"""

content = content.replace(old, new)


path.write_text(content)

PY


chmod +x "$SCRIPT"

echo "Done."
echo ""
echo "Updated:"
echo "- ACTION capitalization handling"
echo "- Model backup before modification"
echo ""
echo "Run again:"
echo "./upgrade_ybnc_to_lightek_contract.sh"