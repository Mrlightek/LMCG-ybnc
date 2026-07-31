#!/bin/bash

set -e

echo "Upgrading Lightek ActivityLog actor tracking..."

GENERATOR="lib/generators/lightek/scaffold"
TEMPLATES="$GENERATOR/templates"

BACKUP="$GENERATOR/backups/activity_actor_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp "$TEMPLATES/activity_log.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/activity_logs_migration.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/job.rb" "$BACKUP/" 2>/dev/null || true


echo "Updating ActivityLog model..."

cat > "$TEMPLATES/activity_log.rb" <<'RUBY'
class ActivityLog < ApplicationRecord


  belongs_to :actor,
    polymorphic: true


  belongs_to :record,
    polymorphic: true



  validates :action,
    presence: true



  validates :status,
    presence: true




  def self.start!(actor:, record:, action:)


    create!(
      actor: actor,
      record: record,
      action: action,
      status: "started"
    )


  end





  def self.complete!(activity, result)


    activity.update!(
      status: "completed",
      message: result.class.name
    )


  end





  def self.fail!(activity, error)


    activity.update!(
      status: "failed",
      message: error.message
    )


  end



end
RUBY



echo "Updating migration template..."

cat > "$TEMPLATES/activity_logs_migration.rb" <<'RUBY'
class CreateActivityLogs < ActiveRecord::Migration[8.0]


  def change


    create_table :activity_logs do |t|


      t.string :action,
        null: false


      t.string :status,
        null: false



      t.references :actor,
        polymorphic: true,
        null: false



      t.references :record,
        polymorphic: true,
        null: false



      t.text :message



      t.timestamps


    end



    add_index :activity_logs,
      [:actor_type, :actor_id]


    add_index :activity_logs,
      [:record_type, :record_id]


    add_index :activity_logs,
      :action


    add_index :activity_logs,
      :status


  end


end
RUBY



echo "Updating PipelineJob actor handling..."

python3 <<'PY'

from pathlib import Path


path = Path(
"lib/generators/lightek/scaffold/templates/job.rb"
)


content = path.read_text()


content = content.replace(
'''actor: actor,
record: record,
action: action
''',
'''actor: actor,
record: record,
action: action.to_s
'''
)


path.write_text(content)

PY



echo ""
echo "Activity actor tracking upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"