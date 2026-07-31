require_relative "ability_analyzer"
require_relative "pipeline_analyzer"
require_relative "contract_issue"

require_relative "view_analyzer"
require_relative "route_analyzer"

module Lightek
  module Generators
    module Helpers

      class ContractValidator


        attr_reader :model_name


        def initialize(model_name)

          @model_name = model_name
          @issues = []

        end



        def validate

          puts ""
          puts "Lightek Contract Validation"
          puts "=========================="
          puts "Model: #{model_name}"
          puts ""


          check_model
          check_schema
          check_routes
          check_views
          check_pipeline
          check_authorization


          report


          @issues.none? do |issue|
            issue[:level] == :error
          end

        end



        private



        def add(level, message, analyzer: :contract, file: nil, line: nil)

          @issues << ContractIssue.new(
            analyzer: analyzer,
            level: level,
            message: message,
            file: file,
            line: line
          )

        end




        def model

          model_name.constantize

        rescue NameError

          nil

        end




        def check_model

          unless model

            add(
              :error,
              "Model #{model_name} does not exist"
            )

            return

          end


          if has_column?("slug")

            unless model.instance_methods.include?(:to_param)

              add(
                :warning,
                "Slug model should define to_param"
              )

            end

          end

        end




        def check_schema

          return unless model


          required =
            model.columns
              .select { |c| c.null == false }
              .map(&:name)



          required.each do |column|

            unless model.column_names.include?(column)

              add(
                :error,
                "Missing required column #{column}"
              )

            end

          end

        end




        def check_routes

          return unless model

          analyzer =
            RouteAnalyzer.new(model)

          analyzer.validate.each do |level, message|

            add(level, message)

          end

        end




        def check_views

          return unless model

          ViewAnalyzer
            .new(model)
            .validate
            .each do |level, message|

              add(level, message)

            end

        end




        def check_pipeline

          return unless model


          PipelineAnalyzer
            .new(model)
            .validate
            .each do |issue|

              @issues << issue

            end

        end




        def check_authorization

          return unless model

          AbilityAnalyzer
            .new(model)
            .validate
            .each do |issue|

              @issues << issue

            end

        end




        def has_column?(name)

          model &&
            model.column_names.include?(name)

        end




        def report


          if @issues.empty?

            puts "✓ Contract valid"

            return

          end



          @issues.each do |issue|

            location =
              [
                issue.file,
                issue.line
              ].compact.join(":")


            prefix =
              location.empty? ?
                "" :
                "#{location} "


            puts "#{prefix}[#{issue.level.upcase}] #{issue.message}"

          end


        end



      end

    end
  end
end
