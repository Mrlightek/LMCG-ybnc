#!/bin/bash

set -e

echo "Fixing Lightek Core namespace endings..."

python3 <<'PY'
from pathlib import Path

files = [
    Path("lib/lightek/contracts/validator.rb"),
    Path("lib/lightek/contracts/issue.rb"),
]

for path in files:

    text = path.read_text()

    text = text.replace(
        "module Lightek\n  module Contracts\n\n\n      class",
        "module Lightek\n  module Contracts\n\n    class"
    )

    # Remove one extra closing module end at EOF
    lines = text.rstrip().splitlines()

    if lines[-3:] == [
        "  end",
        "  end",
        "end"
    ]:
        lines = lines[:-3] + [
            "  end",
            "end"
        ]

    path.write_text(
        "\n".join(lines) + "\n"
    )

PY

echo "Namespace endings fixed."