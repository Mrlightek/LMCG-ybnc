#!/bin/bash

set -e

echo "Adding Lightek relationship support..."

TEMPLATE="lib/generators/lightek/scaffold/templates/model.rb"

if [ ! -f "$TEMPLATE" ]; then
  echo "Error: $TEMPLATE not found"
  echo "Run the Lightek generator setup first."
  exit 1
fi


cat > "$TEMPLATE" <<'RUBY'
class <%= class_name %> < ApplicationRecord

<% attributes.each do |attribute| %>
<% if attribute.type == :references %>
  belongs_to :<%= attribute.name %>
<% end %>

<% if attribute.type.to_s == "has_many" %>
  has_many :<%= attribute.name %>
<% end %>
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


echo "Relationship support added."

echo ""
echo "Examples:"
echo ""
echo "rails g lightek:scaffold Donation user:references amount:decimal note:text"
echo ""
echo "Generates:"
echo "  belongs_to :user"
echo ""
echo "rails g lightek:scaffold User donations:has_many"
echo ""
echo "Generates:"
echo "  has_many :donations"