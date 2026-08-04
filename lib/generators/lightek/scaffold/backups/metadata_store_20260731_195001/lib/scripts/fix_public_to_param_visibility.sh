#!/bin/bash

set -e

echo "Fixing to_param visibility..."

python3 <<'PY'
from pathlib import Path

models = [
    "app/models/event.rb",
    "app/models/initiative.rb",
    "app/models/article.rb",
    "app/models/resource_item.rb"
]

method = """  def to_param
    slug
  end

"""

for file in models:
    path = Path(file)

    if not path.exists():
        continue

    content = path.read_text()

    if "def to_param" not in content:
        continue

    # Remove existing method
    import re

    content = re.sub(
        r'\s*def to_param\s*\n\s*slug\s*\n\s*end\s*\n',
        '\n',
        content
    )

    # Insert before private
    if "\n  private\n" in content:
        content = content.replace(
            "\n  private\n",
            "\n" + method + "  private\n",
            1
        )
    else:
        content = content.rstrip()
        content = content[:-3] + "\n\n" + method + "end\n"

    path.write_text(content)

PY

echo "Done. to_param is now public."