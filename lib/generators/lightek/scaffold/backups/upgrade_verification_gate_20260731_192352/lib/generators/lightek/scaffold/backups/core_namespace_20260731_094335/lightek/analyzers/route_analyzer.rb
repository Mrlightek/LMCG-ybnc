require_relative "../contracts/issue"
module Lightek
  module Generators
    module Helpers

      class RouteAnalyzer

        attr_reader :model

        def initialize(model)

          @model = model

        end

        def validate

          issues = []

          route_file = Rails.root.join("config/routes.rb")

          unless File.exist?(route_file)
            issues << [:error, "config/routes.rb not found"]
            return issues
          end

          routes = File.read(route_file)

          resource =
            model.name.underscore.pluralize

          if routes.include?("resources :#{resource}")

            if slug_model?

              unless routes.match?(
                /resources\s+:#{resource}.*param:\s*:slug/m
              )

                issues << [
                  :warning,
                  "#{resource} uses slug but routes do not specify param: :slug"
                ]

              end

            end

          else

            issues << [
              :warning,
              "No resources route found for #{resource}"
            ]

          end

          issues

        end

        private

        def slug_model?

          model.column_names.include?("slug")

        end

      end

    end
  end
end
