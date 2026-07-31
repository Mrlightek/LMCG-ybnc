#!/usr/bin/env bash

set -e

echo "Upgrading Lightek Doctor issue serialization..."

BACKUP="lib/generators/lightek/scaffold/backups/doctor_issue_serialization_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup..."
mkdir -p "$BACKUP"

cp lib/lightek/contracts/validator.rb "$BACKUP/" 2>/dev/null || true
cp lib/lightek/reporting/*.rb "$BACKUP/" 2>/dev/null || true
cp bin/lightek "$BACKUP/" 2>/dev/null || true


echo "Adding Validator issue reader..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/contracts/validator.rb")

text = path.read_text()

text = text.replace(
    "attr_reader :model_name",
    "attr_reader :model_name, :issues"
)

text = text.replace(
    "@issues = []",
    "@issues = []"
)

path.write_text(text)
PY


echo "Updating Doctor collection..."

python3 <<'PY'
from pathlib import Path

path = Path("bin/lightek")

text = path.read_text()

text = text.replace(
'''issues =
        doctor.instance_variable_get(:@issues)
''',
'''issues =
        doctor.issues
'''
)

text = text.replace(
'''result = {
  errors: errors,
  warnings: warnings
}
''',
'''result = {
  errors: errors,
  warnings: warnings,
  issues: issues.map do |issue|

    {
      analyzer: issue.analyzer,
      level: issue.level,
      message: issue.message,
      file: issue.file,
      line: issue.line
    }

  end
}
'''
)

path.write_text(text)
PY


echo "Updating JSON reporter..."

python3 <<'PY'
from pathlib import Path

path = Path("lib/lightek/reporting/json_reporter.rb")

text = path.read_text()

text = text.replace(
'''puts JSON.pretty_generate(result)
''',
'''puts JSON.pretty_generate(
          {
            summary: {
              errors: result[:errors],
              warnings: result[:warnings]
            },
            issues: result[:issues]
          }
        )
'''
)

path.write_text(text)
PY


echo "Issue serialization upgrade complete."

echo
echo "Backup:"
echo "$BACKUP"
