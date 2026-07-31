module Lightek
  module Contracts

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
