#!/bin/bash

set -e

echo "Upgrading Lightek scaffold to PipelineJob contract..."

GENERATOR="lib/generators/lightek/scaffold"
TEMPLATES="$GENERATOR/templates"

BACKUP="$GENERATOR/backups/pipeline_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp "$GENERATOR/scaffold_generator.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/model.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/service.rb" "$BACKUP/" 2>/dev/null || true
cp "$TEMPLATES/job.rb" "$BACKUP/" 2>/dev/null || true


echo "Updating scaffold generator..."


python3 <<'PY'

from pathlib import Path

path = Path("lib/generators/lightek/scaffold/scaffold_generator.rb")

content = path.read_text()


old = '''      def create_jobs
        %w[create update destroy].each do |action|
          template(
            "job.rb",
            "app/jobs/#{file_name}_#{action}_job.rb",
            { action: action }
          )
        end
      end
'''


new = '''      def create_jobs

        template(
          "job.rb",
          "app/jobs/#{plural_name}/pipeline_job.rb"
        )

      end
'''


if old in content:
    content = content.replace(old,new)

path.write_text(content)

PY


echo "Writing PipelineJob template..."

cat > "$TEMPLATES/job.rb" <<'RUBY'
module <%= class_name.pluralize %>
  class PipelineJob < ApplicationJob

    queue_as :default


    def perform(action:, id:, actor:)

      record = <%= class_name %>.find_by(id: id)


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

    end

  end
end
RUBY


echo "Updating service template..."

cat > "$TEMPLATES/service.rb" <<'RUBY'
module <%= class_name.pluralize %>

  class <%= action.capitalize %>Service


    def self.call(actor:, record:)

      new(
        actor: actor,
        record: record
      ).call

    end



    def initialize(actor:, record:)

      @actor = actor
      @record = record

    end



    def call

      # <%= action.capitalize %> business logic

      record

    end



    private


    attr_reader :actor, :record


  end

end
RUBY



echo "Updating model template..."

cat > "$TEMPLATES/model.rb" <<'RUBY'
class <%= class_name %> < ApplicationRecord


<% attributes.each do |attribute| %>

<% if attribute.type == :references %>
  belongs_to :<%= attribute.name %>
<% end %>

<% end %>



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



echo ""
echo "Pipeline contract upgrade complete."
echo ""
echo "Backup created:"
echo "$BACKUP"
echo ""
echo "Run:"
echo "ruby -c lib/generators/lightek/scaffold/scaffold_generator.rb"