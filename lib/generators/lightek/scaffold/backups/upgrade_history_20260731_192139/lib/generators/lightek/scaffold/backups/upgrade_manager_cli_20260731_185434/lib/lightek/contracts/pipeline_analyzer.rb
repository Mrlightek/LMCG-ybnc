require_relative "issue"

module Lightek
  module Contracts

      class PipelineAnalyzer

        attr_reader :model

        def initialize(model)

          @model = model

        end


        def validate

          issues = []

          check_model_hooks(issues)

          check_pipeline_job(issues)

          check_services(issues)

          check_supporting_components(issues)

          issues

        end



        private



        def check_model_hooks(issues)

          required = %i[
            pipeline_create
            pipeline_update
            pipeline_destroy
          ]


          existing =
            model.private_instance_methods


          required.each do |hook|

            unless existing.include?(hook)

              issues << ContractIssue.new(
                analyzer: :pipeline,
                level: :error,
                message: "Missing model pipeline hook #{hook}"
              )

            end

          end

        end




        def check_pipeline_job(issues)

          path =
            Rails.root.join(
              "app/jobs/#{model.name.underscore.pluralize}_pipeline_job.rb"
            )


          unless File.exist?(path)

            issues << ContractIssue.new(
              analyzer: :pipeline,
              level: :error,
              message: "Missing PipelineJob #{path}"
            )

          end

        end




        def check_services(issues)

          base =
            Rails.root.join(
              "app/services/#{model.name.underscore.pluralize}"
            )


          %w[
            create_service.rb
            update_service.rb
            destroy_service.rb
          ].each do |service|


            unless File.exist?(base.join(service))

              issues << ContractIssue.new(
                analyzer: :pipeline,
                level: :warning,
                message: "Missing pipeline service #{service}"
              )

            end


          end

        end




        def check_supporting_components(issues)

          files = {

            mailer:
              "app/mailers/#{model.name.underscore}_mailer.rb",

            notification:
              "app/notifications/#{model.name.underscore}_notification.rb",

            event:
              "app/events/#{model.name.underscore}_event.rb"

          }



          files.each do |name, file|

            unless File.exist?(Rails.root.join(file))

              issues << ContractIssue.new(
                analyzer: :pipeline,
                level: :warning,
                message: "Missing #{name} component #{file}"
              )

            end

          end

        end


      end

    end
  end
