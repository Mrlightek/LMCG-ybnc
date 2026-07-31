#!/bin/bash

set -e

echo "Fixing Lightek Doctor loader..."

FILE="bin/lightek"

cp "$FILE" "$FILE.before_loader_fix"


python3 <<'PY'
from pathlib import Path

path = Path("bin/lightek")

content = path.read_text()

loader = '''
require_relative "../lib/generators/lightek/helpers/contract_validator"
require_relative "../lib/generators/lightek/helpers/contract_analyzer"
require_relative "../lib/generators/lightek/helpers/contract_issue"
require_relative "../lib/generators/lightek/helpers/view_analyzer"
require_relative "../lib/generators/lightek/helpers/route_analyzer"
'''

if "contract_validator" not in content:
    content = content.replace(
        'require_relative "../config/environment"',
        'require_relative "../config/environment"\n' + loader
    )

path.write_text(content)
PY


chmod +x bin/lightek

echo "Lightek Doctor loader fixed."