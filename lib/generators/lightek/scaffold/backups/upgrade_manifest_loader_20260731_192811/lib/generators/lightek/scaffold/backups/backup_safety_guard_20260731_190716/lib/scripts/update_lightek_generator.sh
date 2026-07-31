#!/bin/bash

set -e

echo "Updating Lightek event-driven scaffold generator..."

BASE="lib/generators/lightek/scaffold"
TEMPLATES="$BASE/templates"

mkdir -p "$TEMPLATES/views"

cat > "$BASE/scaffold_generator.rb" <<'RUBY'
require "rails/generators"

module Lightek
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase

      source_root File.expand_path("templates", __dir__)

      argument :attributes,
        type: :array,
        default: [],
        banner: "field:type field:type"


      def create_model
        template(
          "model.rb",
          "app/models/#{file_name}.rb"
        )
      end


      def create_services
        %w[create update destroy].each do |action|
          template(
            "service.rb",
            "app/services/#{file_name}_#{action}_service.rb",
            { action: action }
          )
        end
      end


      def create_jobs
        %w[create update destroy].each do |action|
          template(
            "job.rb",
            "app/jobs/#{file_name}_#{action}_job.rb",
            { action: action }
          )
        end
      end


      def create_mailer
        template(
          "mailer.rb",
          "app/mailers/#{file_name}_mailer.rb"
        )
      end


      def create_notification
        template(
          "notification.rb",
          "app/notifications/#{file_name}_notification.rb"
        )
      end


      def create_event
        template(
          "event.rb",
          "app/events/#{file_name}_event.rb"
        )
      end


      def create_controller
        template(
          "controller.rb",
          "app/controllers/#{plural_name}_controller.rb"
        )
      end


      def create_views
        directory(
          "views",
          "app/views/#{plural_name}"
        )
      end

    end
  end
end
RUBY


cat > "$TEMPLATES/model.rb" <<'RUBY'
class <%= class_name %> < ApplicationRecord

<% attributes.each do |attribute| %>
  # attribute :<%= attribute.name %>, :<%= attribute.type %>
<% end %>


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    <%= class_name %>CreateJob.perform_later(id)
  end


  def trigger_update_job
    <%= class_name %>UpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    <%= class_name %>DestroyJob.perform_later(id)
  end

end
RUBY


cat > "$TEMPLATES/job.rb" <<'RUBY'
class <%= class_name %><%= action.capitalize %>Job < ApplicationJob

  queue_as :default


  def perform(id)

    record = <%= class_name %>.find_by(id: id)

    result = <%= class_name %><%= action.capitalize %>Service.call(record)


    <%= class_name %>Mailer
      .completed(result)
      .deliver_later


    <%= class_name %>Notification
      .broadcast(result)


    <%= class_name %>Event.log(
      result,
      "<%= action %>"
    )

  end

end
RUBY


cat > "$TEMPLATES/service.rb" <<'RUBY'
class <%= class_name %><%= action.capitalize %>Service


  def self.call(record)
    new(record).call
  end


  def initialize(record)
    @record = record
  end


  def call

    # <%= action.capitalize %> business logic goes here

    @record

  end


end
RUBY


cat > "$TEMPLATES/mailer.rb" <<'RUBY'
class <%= class_name %>Mailer < ApplicationMailer


  def completed(result)

    @result = result

    mail(
      subject: "<%= class_name %> process completed"
    )

  end


end
RUBY


cat > "$TEMPLATES/notification.rb" <<'RUBY'
class <%= class_name %>Notification


  def self.broadcast(result)

    # Push notifications
    # WebSocket events
    # Mobile notifications

  end


end
RUBY


cat > "$TEMPLATES/event.rb" <<'RUBY'
class <%= class_name %>Event


  def self.log(result, action)

    EventLog.create!(
      event_type: "#{action}_<%= file_name %>",
      data: result
    )

  end


end
RUBY


echo "Lightek generator updated."
echo ""
echo "Test with:"
echo ""
echo "rails g lightek:scaffold Donation amount:decimal note:text"