#!/bin/bash

set -e

echo "Fixing Lightek Core require paths..."

python3 <<'PY'
from pathlib import Path

files = [
    Path("lib/lightek/contracts/validator.rb"),
    Path("lib/lightek/contracts/analyzer.rb"),
    Path("lib/lightek/contracts/ability_analyzer.rb"),
    Path("lib/lightek/contracts/pipeline_analyzer.rb"),
]

for path in files:

    if not path.exists():
        continue

    text = path.read_text()

    text = text.replace(
        'require_relative "view_analyzer"',
        'require_relative "../analyzers/view_analyzer"'
    )

    text = text.replace(
        'require_relative "route_analyzer"',
        'require_relative "../analyzers/route_analyzer"'
    )

    text = text.replace(
        'require_relative "schema_analyzer"',
        'require_relative "../analyzers/schema_analyzer"'
    )

    text = text.replace(
        'require_relative "ability_analyzer"',
        'require_relative "ability_analyzer"'
    )

    path.write_text(text)

PY

echo "Require paths fixed."