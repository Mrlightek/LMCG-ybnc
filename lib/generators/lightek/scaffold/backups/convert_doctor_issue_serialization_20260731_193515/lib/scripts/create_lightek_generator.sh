#!/bin/bash

set -e

echo "Creating Lightek scaffold generator..."

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
        invoke "active_record:model", [name, *attributes]
      end

      def create_controller
        template(
          "controller.rb",
          "app/controllers/#{plural_name}_controller.rb"
        )
      end

      def create_service
        template(
          "service.rb",
          "app/services/#{file_name}_service.rb"
        )
      end

      def create_job
        template(
          "job.rb",
          "app/jobs/#{file_name}_job.rb"
        )
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


cat > "$TEMPLATES/controller.rb" <<'RUBY'
class <%= class_name.pluralize %>Controller < ApplicationController

  before_action :set_<%= file_name %>, only: %i[show edit update destroy]

  def index
    @<%= plural_name %> = <%= class_name %>.all
  end

  def show
  end

  def new
    @<%= file_name %> = <%= class_name %>.new
  end

  def create
    @<%= file_name %> = <%= class_name %>.new(<%= file_name %>_params)

    if @<%= file_name %>.save
      <%= class_name %>Job.perform_later(@<%= file_name %>.id)
      redirect_to @<%= file_name %>
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @<%= file_name %>.update(<%= file_name %>_params)
      <%= class_name %>Job.perform_later(@<%= file_name %>.id)
      redirect_to @<%= file_name %>
    else
      render :edit
    end
  end

  def destroy
    @<%= file_name %>.destroy
    redirect_to <%= plural_name %>_path
  end

  private

  def set_<%= file_name %>
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  def <%= file_name %>_params
    params.require(:<%= file_name %>).permit!
  end

end
RUBY


cat > "$TEMPLATES/service.rb" <<'RUBY'
class <%= class_name %>Service

  def self.call(...)
    new(...).call
  end

  def initialize(<%= file_name %>)
    @<%= file_name %> = <%= file_name %>
  end

  def call

    # Business logic goes here

    @<%= file_name %>

  end

end
RUBY


cat > "$TEMPLATES/job.rb" <<'RUBY'
class <%= class_name %>Job < ApplicationJob

  queue_as :default

  def perform(<%= file_name %>_id)

    <%= file_name %> = <%= class_name %>.find(<%= file_name %>_id)

    result = <%= class_name %>Service.call(<%= file_name %>)

    <%= class_name %>Mailer.completed(result).deliver_later

    <%= class_name %>Notification.broadcast(result)

    EventLog.create!(
      event_type: "<%= file_name %>_completed",
      data: result
    )

  end

end
RUBY


cat > "$TEMPLATES/mailer.rb" <<'RUBY'
class <%= class_name %>Mailer < ApplicationMailer

  def completed(result)
    @result = result

    mail(
      subject: "<%= class_name %> completed"
    )
  end

end
RUBY


cat > "$TEMPLATES/notification.rb" <<'RUBY'
class <%= class_name %>Notification

  def self.broadcast(result)

    # Notification handling

  end

end
RUBY


cat > "$TEMPLATES/event.rb" <<'RUBY'
class <%= class_name %>Event

  def self.log(result)

    EventLog.create!(
      event_type: "<%= file_name %>",
      data: result
    )

  end

end
RUBY


cat > "$TEMPLATES/views/index.html.erb" <<'ERB'
<h1><%= plural_name.humanize %></h1>

<%% @<%= plural_name %>.each do |<%= file_name %>| %>

  <div>
    <%%= link_to <%= file_name %>.id, <%= file_name %> %>
  </div>

<%% end %>
ERB


cat > "$TEMPLATES/views/show.html.erb" <<'ERB'
<h1><%= class_name %></h1>

<% attributes.each do |attribute| %>
<p>
  <strong><%= attribute.human_name %>:</strong>
  <%%= @<%= file_name %>.<%= attribute.name %> %>
</p>
<% end %>
ERB


cat > "$TEMPLATES/views/new.html.erb" <<'ERB'
<h1>New <%= class_name %></h1>

<%%= render "form", <%= file_name %>: @<%= file_name %> %>
ERB


cat > "$TEMPLATES/views/edit.html.erb" <<'ERB'
<h1>Edit <%= class_name %></h1>

<%%= render "form", <%= file_name %>: @<%= file_name %> %>
ERB


cat > "$TEMPLATES/views/_form.html.erb" <<'ERB'
<%%= form_with(model: <%= file_name %>) do |form| %>

  <% attributes.each do |attribute| %>

  <div>
    <%%= form.label :<%= attribute.name %> %>
    <%%= form.<%= attribute.field_type %> :<%= attribute.name %> %>
  </div>

  <% end %>

  <%%= form.submit %>

<%% end %>
ERB


echo "Lightek generator created."
echo ""
echo "Run:"
echo "rails g lightek:scaffold ModelName field:type field:type"