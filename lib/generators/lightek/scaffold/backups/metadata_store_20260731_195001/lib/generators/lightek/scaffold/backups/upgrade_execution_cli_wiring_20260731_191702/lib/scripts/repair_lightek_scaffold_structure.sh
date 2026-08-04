#!/bin/bash

set -e

FILE="lib/generators/lightek/scaffold/scaffold_generator.rb"

echo "Repairing Lightek scaffold generator structure..."

cp "$FILE" "${FILE}.before_structure_fix"

python3 <<'PY'
from pathlib import Path

path = Path("lib/generators/lightek/scaffold/scaffold_generator.rb")

content = path.read_text()

# Remove misplaced closing modules before analyze_contract
content = content.replace(
"""
    end
  end



      def analyze_contract
""",
"""
      def analyze_contract
"""
)

# Move final module endings to proper location
content = content.replace(
"""
      end


end
""",
"""
      end

    end
  end
end
"""
)

# Fix escaped newline artifact
content = content.replace(
"\\n      def create_views",
"      def create_views"
)

path.write_text(content)
PY

echo "Structure repaired."
echo "Backup:"
echo "${FILE}.before_structure_fix"