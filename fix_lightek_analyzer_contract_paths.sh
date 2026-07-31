#!/bin/bash

set -e

echo "Fixing Lightek analyzer contract paths..."

python3 <<'PY'
from pathlib import Path

files = [
    Path("lib/lightek/analyzers/view_analyzer.rb"),
    Path("lib/lightek/analyzers/route_analyzer.rb"),
    Path("lib/lightek/analyzers/schema_analyzer.rb"),
]

for path in files:

    if not path.exists():
        continue

    text = path.read_text()

    text = text.replace(
        'require_relative "contract_issue"',
        'require_relative "../contracts/issue"'
    )

    text = text.replace(
        'require_relative "issue"',
        'require_relative "../contracts/issue"'
    )

    path.write_text(text)

PY

echo "Analyzer contract paths fixed."