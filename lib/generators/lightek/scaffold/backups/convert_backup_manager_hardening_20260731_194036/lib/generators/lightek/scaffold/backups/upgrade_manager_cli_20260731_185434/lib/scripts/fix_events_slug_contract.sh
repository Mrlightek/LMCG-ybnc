#!/bin/bash

set -e

echo "Fixing Events slug contract..."

# Backup files
cp app/models/event.rb app/models/event.rb.backup
cp app/controllers/events_controller.rb app/controllers/events_controller.rb.backup


python3 <<'PY'
from pathlib import Path


# Add slug routing to Event model
model = Path("app/models/event.rb")

content = model.read_text()

if "def to_param" not in content:

    content = content.rstrip()

    content = content[:-3] + """

  def to_param
    slug
  end

end
"""

model.write_text(content)



# Update controller
controller = Path("app/controllers/events_controller.rb")

content = controller.read_text()


content = content.replace(
    '@event = Event.published.find_by!(slug: params[:id])',
    '@event = Event.published.find_by!(slug: params[:slug])'
)


controller.write_text(content)

PY


echo ""
echo "Events slug contract applied."
echo ""
echo "Backups created:"
echo "app/models/event.rb.backup"
echo "app/controllers/events_controller.rb.backup"