#!/bin/bash

set -e

echo "Upgrading Lightek Current context..."

APP_MODELS="app/models"
GENERATOR="lib/generators/lightek/scaffold"
BACKUP="$GENERATOR/backups/current_context_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"


echo "Creating backup..."

cp "$APP_MODELS/current.rb" "$BACKUP/" 2>/dev/null || true


echo "Creating Current model..."


mkdir -p "$APP_MODELS"


cat > "$APP_MODELS/current.rb" <<'RUBY'
class Current < ActiveSupport::CurrentAttributes

  attribute :actor
  attribute :user
  attribute :request_id


  resets do

    Time.zone = nil

  end


end
RUBY



echo "Creating generator template..."

mkdir -p "$GENERATOR/templates/current"


cat > "$GENERATOR/templates/current/current.rb" <<'RUBY'
class Current < ActiveSupport::CurrentAttributes

  attribute :actor
  attribute :user
  attribute :request_id

end
RUBY



echo "Updating controller template..."

python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/templates/controller.rb"
)

content = path.read_text()


hook = '''
  before_action :set_current_context

'''


if "set_current_context" not in content:

    content = content.replace(
        "  before_action :authorize_<%= file_name %>",
        "  before_action :authorize_<%= file_name %>\n\n" + hook
    )



method = '''

  def set_current_context

    Current.user =
      respond_to?(:current_user) ?
        current_user :
        nil


    Current.actor =
      Current.user


    Current.request_id =
      request.request_id


  end

'''


if "def set_current_context" not in content:

    content = content.replace(
        "\n  private\n",
        "\n" + method + "\n  private\n"
    )


path.write_text(content)

PY



echo "Updating generator wiring..."


python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()


if "create_current" not in content:

    marker = "      def create_model"

    method = '''
      def create_current

        template(
          "current/current.rb",
          "app/models/current.rb"
        )

      end


'''

    content = content.replace(
        marker,
        method + marker
    )


path.write_text(content)

PY



echo ""
echo "Current context upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"