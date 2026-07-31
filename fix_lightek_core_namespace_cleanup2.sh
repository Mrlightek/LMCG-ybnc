#!/bin/bash

set -e

echo "Cleaning Lightek Core namespace endings..."

python3 <<'PY'
from pathlib import Path

# Fix validator ending
path = Path("lib/lightek/contracts/validator.rb")
text = path.read_text()

text = text.rstrip()

if text.endswith("""      end

    end
  end
end"""):
    text = text[:-len("""      end

    end
  end
end""")] + """      end

    end
  end
"""

path.write_text(text)


# Normalize issue files
for filename in [
    "lib/lightek/contracts/issue.rb",
    "lib/lightek/contracts/contract_issue.rb"
]:
    path = Path(filename)
    text = path.read_text()

    text = text.replace(
        "  module Contracts\n\n      ContractIssue",
        "  module Contracts\n\n    ContractIssue"
    )

    text = text.rstrip()

    text = text.replace(
        """
    end
  end
end
""",
        """
  end
end
"""
    )

    path.write_text(text)

PY

echo "Core namespace cleanup complete."
