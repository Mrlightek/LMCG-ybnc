#!/bin/bash

set -e

echo "Upgrading Lightek schema-driven views..."

GENERATOR="lib/generators/lightek/scaffold"
HELPERS="lib/generators/lightek/helpers"

BACKUP="$GENERATOR/backups/schema_views_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp "$HELPERS/view_generator.rb" "$BACKUP/" 2>/dev/null || true
cp "$GENERATOR/scaffold_generator.rb" "$BACKUP/" 2>/dev/null || true


echo "Updating ViewGenerator..."

cat > "$HELPERS/view_generator.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class ViewGenerator


        def initialize(model)

          @model = model

        end



        def fields

          model.columns.reject do |column|

            %w[
              id
              created_at
              updated_at
            ].include?(column.name)

          end

        end




        def input_for(column)


          case column.type.to_sym


          when :text

            "text_area"


          when :boolean

            "check_box"


          when :date

            "date_field"


          when :datetime

            "datetime_field"


          when :integer

            "number_field"


          when :decimal

            "number_field"


          else

            "text_field"


          end


        end



        private


        attr_reader :model


      end

    end
  end
end
RUBY



echo "Updating scaffold generator..."

python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()


old = '''
      def create_views
        directory(
          "views",
          "app/views/#{plural_name}"
        )
      end
'''


new = '''
      def create_views

        generator =
          Lightek::Generators::Helpers::ViewGenerator.new(
            file_name.classify.constantize
          )


        template(
          "views/index.html.erb",
          "app/views/#{plural_name}/index.html.erb"
        )


        template(
          "views/show.html.erb",
          "app/views/#{plural_name}/show.html.erb"
        )


        template(
          "views/_form.html.erb",
          "app/views/#{plural_name}/_form.html.erb"
        )


        template(
          "views/new.html.erb",
          "app/views/#{plural_name}/new.html.erb"
        )


        template(
          "views/edit.html.erb",
          "app/views/#{plural_name}/edit.html.erb"
        )


      end
'''


if old in content:

    content = content.replace(old,new)


path.write_text(content)

PY



echo "Adding dynamic form template..."

cat > "$GENERATOR/templates/views/_form.html.erb" <<'ERB'
<%%= form_with(model: <%= file_name %>) do |form| %>

  <% attributes.each do |attribute| %>

    <div>

      <%%= form.label :<%= attribute.name %> %>

      <%%= form.<%= 
        case attribute.type.to_sym
        when :text
          "text_area"
        when :boolean
          "check_box"
        when :integer, :decimal
          "number_field"
        else
          "text_field"
        end
      %> :<%= attribute.name %> %>

    </div>

  <% end %>


  <div>

    <%%= form.submit %>

  </div>


<%% end %>
ERB



echo ""
echo "Schema-driven views upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"