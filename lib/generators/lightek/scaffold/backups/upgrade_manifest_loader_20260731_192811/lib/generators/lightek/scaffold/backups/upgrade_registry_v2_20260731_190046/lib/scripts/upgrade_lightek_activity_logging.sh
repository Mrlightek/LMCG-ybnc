#!/bin/bash

set -e

echo "Upgrading Lightek pipeline with ActivityLog..."

GENERATOR="lib/generators/lightek/scaffold"
TEMPLATES="$GENERATOR/templates"

BACKUP="$GENERATOR/backups/activity_logging_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp "$GENERATOR/scaffold_generator.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/model.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/job.rb" "$BACKUP/" 2>/dev/null || true


echo "Adding ActivityLog generator support..."

python3 <<'PY'

from pathlib import Path


path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)


content = path.read_text()


insert = '''

      def create_activity_log

        template(
          "activity_log.rb",
          "app/models/activity_log.rb"
        )

        template(
          "activity_logs_migration.rb",
          "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_activity_logs.rb"
        )

      end

'''


marker = "      def create_ability"


if insert not in content:
    content = content.replace(marker, insert + marker)


path.write_text(content)

PY


echo "Updating model template..."

cat > "$TEMPLATES/model.rb" <<'RUBY'
class <%= class_name %> < ApplicationRecord


<% attributes.each do |attribute| %>

<% if attribute.type == :references %>
  belongs_to :<%= attribute.name %>
<% end %>

<% end %>


  has_many :activity_logs,
    as: :record,
    dependent: :destroy



  after_create_commit  { enqueue_pipeline(:create) }
  after_update_commit  { enqueue_pipeline(:update) }
  after_destroy_commit { enqueue_pipeline(:destroy) }



  private



  def enqueue_pipeline(action)

    <%= class_name.pluralize %>::PipelineJob.perform_later(
      action: action,
      id: id,
      actor: Actors::SystemActor.new
    )

  end


end
RUBY



echo "Updating PipelineJob..."

cat > "$TEMPLATES/job.rb" <<'RUBY'
module <%= class_name.pluralize %>

  class PipelineJob < ApplicationJob


    queue_as :default



    def perform(action:, id:, actor:)


      record = <%= class_name %>.find_by(id: id)


      activity = ActivityLog.start!(
        actor: actor,
        record: record,
        action: action
      )


      begin


        result =
          case action.to_sym

          when :create

            <%= class_name.pluralize %>::CreateService.call(
              actor: actor,
              record: record
            )


          when :update

            <%= class_name.pluralize %>::UpdateService.call(
              actor: actor,
              record: record
            )


          when :destroy

            <%= class_name.pluralize %>::DestroyService.call(
              actor: actor,
              record: record
            )

          end



        ActivityLog.complete!(activity, result)


      rescue => error


        ActivityLog.fail!(
          activity,
          error
        )


        raise error


      end


    end


  end

end
RUBY



echo "Creating ActivityLog model..."

cat > "$TEMPLATES/activity_log.rb" <<'RUBY'
class ActivityLog < ApplicationRecord


  belongs_to :record,
    polymorphic: true



  def self.start!(actor:, record:, action:)

    create!(
      actor_type: actor.class.name,
      action: action,
      status: "started",
      record: record
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



echo "Creating migration template..."

cat > "$TEMPLATES/activity_logs_migration.rb" <<'RUBY'
class CreateActivityLogs < ActiveRecord::Migration[8.0]

  def change

    create_table :activity_logs do |t|

      t.string :action
      t.string :status

      t.string :actor_type

      t.references :record,
        polymorphic: true

      t.text :message

      t.timestamps

    end

  end

end
RUBY



echo ""
echo "Activity logging upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"