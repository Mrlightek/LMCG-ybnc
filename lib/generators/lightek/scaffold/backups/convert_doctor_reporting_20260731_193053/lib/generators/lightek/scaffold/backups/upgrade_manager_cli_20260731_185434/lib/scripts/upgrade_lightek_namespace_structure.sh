#!/bin/bash

set -e

echo "Upgrading Lightek generator namespaces..."

GENERATOR="lib/generators/lightek/scaffold"

BACKUP="$GENERATOR/backups/namespace_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

cp "$GENERATOR/scaffold_generator.rb" "$BACKUP/"


python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()


content = content.replace(
'''      def create_services
        %w[create update destroy].each do |action|
          template(
            "service.rb",
            "app/services/#{file_name}_#{action}_service.rb",
            { action: action }
          )
        end
      end
''',
'''      def create_services

        %w[create update destroy].each do |action|

          template(
            "service.rb",
            "app/services/#{plural_name}/#{action}_service.rb",
            { action: action }
          )

        end

      end
'''
)


content = content.replace(
'''      def create_mailer
        template(
          "mailer.rb",
          "app/mailers/#{file_name}_mailer.rb"
        )
      end
''',
'''      def create_mailer

        template(
          "mailer.rb",
          "app/mailers/#{plural_name}/mailer.rb"
        )

      end
'''
)


content = content.replace(
'''      def create_notification
        template(
          "notification.rb",
          "app/notifications/#{file_name}_notification.rb"
        )
      end
''',
'''      def create_notification

        template(
          "notification.rb",
          "app/notifications/#{plural_name}/notification.rb"
        )

      end
'''
)


content = content.replace(
'''      def create_event
        template(
          "event.rb",
          "app/events/#{file_name}_event.rb"
        )
      end
''',
'''      def create_event

        template(
          "event.rb",
          "app/events/#{plural_name}/activity_event.rb"
        )

      end
'''
)


path.write_text(content)

PY


echo ""
echo "Namespace structure upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"