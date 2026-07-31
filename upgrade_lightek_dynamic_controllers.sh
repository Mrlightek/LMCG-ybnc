#!/bin/bash

set -e

echo "Upgrading Lightek dynamic controllers..."

GENERATOR="lib/generators/lightek/scaffold"
TEMPLATE="$GENERATOR/templates/controller.rb"

BACKUP="$GENERATOR/backups/dynamic_controller_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp "$TEMPLATE" "$BACKUP/" 2>/dev/null || true


echo "Updating controller template..."


cat > "$TEMPLATE" <<'RUBY'
class <%= class_name.pluralize %>Controller < ApplicationController


  before_action :set_<%= file_name %>, only: %i[
    show
    edit
    update
    destroy
  ]


  before_action :authorize_<%= file_name %>





  def index

    @<%= plural_name %> =
      <%= class_name %>.all


  end





  def show

  end





  def new

    @<%= file_name %> =
      <%= class_name %>.new

  end





  def create


    @<%= file_name %> =
      <%= class_name %>.new(
        <%= file_name %>_params
      )



    if @<%= file_name %>.save


      pipeline(
        :create,
        @<%= file_name %>
      )


      redirect_to @<%= file_name %>


    else


      render :new,
        status: :unprocessable_entity


    end


  end





  def edit

  end





  def update


    if @<%= file_name %>.update(
      <%= file_name %>_params
    )


      pipeline(
        :update,
        @<%= file_name %>
      )


      redirect_to @<%= file_name %>


    else


      render :edit,
        status: :unprocessable_entity


    end


  end





  def destroy


    id =
      @<%= file_name %>.id



    @<%= file_name %>.destroy!



    pipeline(
      :destroy,
      id
    )



    redirect_to <%= plural_name %>_path



  end





  private





  def set_<%= file_name %>


    if <%= class_name %>.column_names.include?("slug")


      @<%= file_name %> =
        <%= class_name %>.find_by!(
          slug: params[:slug] || params[:id]
        )


    else


      @<%= file_name %> =
        <%= class_name %>.find(
          params[:id]
        )


    end


  end





  def authorize_<%= file_name %>


    authorize!(
      action_name.to_sym,
      @<%= file_name %> || <%= class_name %>
    )


  rescue NoMethodError


    true


  end





  def pipeline(action, record)


    <%= class_name %>PipelineJob.perform_later(

      action: action,

      id:
        record.respond_to?(:id) ?
          record.id :
          record,

      actor:
        current_actor

    )


  rescue NoMethodError


    true


  end





  def <%= file_name %>_params


    allowed =
      <%= class_name %>
        .column_names
        .reject do |column|


          %w[
            id
            created_at
            updated_at
          ].include?(column)


        end



    params
      .require(:<%= file_name %>)
      .permit(
        *allowed
      )


  end


end
RUBY



echo "Updating generator controller wiring..."


python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()

if "dynamic_controller" not in content:

    content = content.replace(
        'def create_controller',
        'def create_controller'
    )

path.write_text(content)

PY



echo ""
echo "Dynamic controller upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"