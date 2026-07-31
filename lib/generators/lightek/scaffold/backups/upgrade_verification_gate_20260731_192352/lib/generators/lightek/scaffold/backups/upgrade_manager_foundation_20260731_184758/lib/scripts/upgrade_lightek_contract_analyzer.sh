#!/bin/bash

set -e

echo "Upgrading Lightek Contract Analyzer..."

GENERATOR="lib/generators/lightek/scaffold"

HELPERS="lib/generators/lightek/helpers"
BACKUP="$GENERATOR/backups/contract_analyzer_upgrade_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"

echo "Creating backup..."

cp -r "$HELPERS" "$BACKUP/" 2>/dev/null || true


echo "Creating ContractAnalyzer..."

cat > "$HELPERS/contract_analyzer.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class ContractAnalyzer


        def initialize(model)

          @model = model

        end




        def report


          {

            model: model_name,

            schema: schema_report,

            associations: association_report,

            pipeline: pipeline_report,

            views: view_report,

            abilities: ability_report

          }


        end





        private



        attr_reader :model





        def model_name

          @model.name

        end





        def schema_report

          model.column_names

        rescue

          []

        end





        def association_report

          model.reflect_on_all_associations.map do |association|

            "#{association.macro} #{association.name}"

          end


        rescue

          []

        end





        def pipeline_report


          actions = %w[
            create
            update
            destroy
          ]


          actions.map do |action|

            {

              action: action,

              service:
                File.exist?(
                  "app/services/#{model.table_name}/#{action}_service.rb"
                ),


              job:
                File.exist?(
                  "app/jobs/#{model.table_name}/pipeline_job.rb"
                )

            }


          end


        end





        def view_report


          path =
            "app/views/#{model.table_name}"



          {

            index:
              File.exist?("#{path}/index.html.erb"),


            show:
              File.exist?("#{path}/show.html.erb"),


            form:
              File.exist?("#{path}/_form.html.erb")

          }


        end





        def ability_report


          File.exist?(
            "app/models/ability.rb"
          )


        end



      end

    end
  end
end
RUBY



echo "Adding analyzer require..."

python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()

require_line = '''
require_relative "../helpers/contract_analyzer"
'''

if "contract_analyzer" not in content:
    content = require_line + "\n" + content

path.write_text(content)

PY



echo "Adding contract command..."

python3 <<'PY'

from pathlib import Path

path = Path(
"lib/generators/lightek/scaffold/scaffold_generator.rb"
)

content = path.read_text()

marker = "def analyze_contract"

if marker not in content:

    insert = '''

      def analyze_contract


        say ""

        say "Lightek Contract Analysis"

        say "-------------------------"


        model = file_name.classify.constantize


        report =
          Lightek::Generators::Helpers::ContractAnalyzer
            .new(model)
            .report



        report.each do |key,value|

          say "#{key}:"

          say value.inspect

        end


        say ""

      rescue NameError

        say "Model unavailable until application loads."


      end


'''

    content += insert


path.write_text(content)

PY



echo ""
echo "Contract Analyzer upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"