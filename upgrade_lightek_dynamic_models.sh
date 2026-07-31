#!/bin/bash

set -e

echo "Upgrading Lightek dynamic models..."

GENERATOR="lib/generators/lightek/scaffold"
TEMPLATE="$GENERATOR/templates/model.rb"

BACKUP="$GENERATOR/backups/dynamic_models_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp "$TEMPLATE" "$BACKUP/" 2>/dev/null || true


echo "Updating model template..."


cat > "$TEMPLATE" <<'RUBY'
class <%= class_name %> < ApplicationRecord


<% attributes.each do |attribute| %>


<% if attribute.type == :references %>

  belongs_to :<%= attribute.name %>

<% end %>


<% if attribute.type.to_s == "has_many" %>

  has_many :<%= attribute.name %>

<% end %>


<% if attribute.type.to_s == "has_one" %>

  has_one :<%= attribute.name %>

<% end %>


<% end %>





  before_validation :generate_slug,
    if: -> {
      respond_to?(:slug) &&
      slug.blank?
    }





  after_create_commit :pipeline_create

  after_update_commit :pipeline_update

  after_destroy_commit :pipeline_destroy





<% attributes.each do |attribute| %>


<% if [:string, :text].include?(attribute.type.to_sym) %>

  validates :<%= attribute.name %>,
    presence: true

<% end %>


<% end %>





  scope :recent,
    -> {
      order(
        created_at: :desc
      )
    }





  private





  def generate_slug

    self.slug =
      title.parameterize

  rescue NoMethodError

    nil

  end





  def pipeline_create

    <%= class_name %>PipelineJob.perform_later(

      action: :create,

      id: id,

      actor: Current.actor

    )

  end





  def pipeline_update

    <%= class_name %>PipelineJob.perform_later(

      action: :update,

      id: id,

      actor: Current.actor

    )

  end





  def pipeline_destroy

    <%= class_name %>PipelineJob.perform_later(

      action: :destroy,

      id: id,

      actor: Current.actor

    )

  end





end
RUBY



echo "Updating generator model analyzer support..."


python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()


require_line = 'require_relative "../helpers/contract_analyzer"'


if require_line not in content:

    content = (
        require_line +
        "\n" +
        content
    )



if "analyze_model_contract" not in content:

    marker = "      def create_model"

    insert = '''
      def analyze_model_contract

        analyzer =
          Lightek::Generators::Helpers::ContractAnalyzer.new(
            file_name.classify
          )

        analyzer.report(self)

      end


'''

    content = content.replace(
        marker,
        insert + marker
    )


path.write_text(content)

PY



echo ""
echo "Dynamic models upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"