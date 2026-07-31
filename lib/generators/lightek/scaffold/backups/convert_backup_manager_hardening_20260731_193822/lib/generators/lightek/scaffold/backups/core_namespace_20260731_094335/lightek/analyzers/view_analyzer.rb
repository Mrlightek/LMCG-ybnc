require_relative "../contracts/issue"
module Lightek
  module Generators
    module Helpers

      class ViewAnalyzer

        attr_reader :model

        def initialize(model)
          @model = model
        end

        def validate

          issues = []

          views =
            Rails.root.join(
              "app/views",
              model.name.underscore.pluralize
            )

          unless Dir.exist?(views)

            issues << [
              :warning,
              "View directory #{views} does not exist"
            ]

            return issues

          end

          required = %w[
            index.html.erb
            show.html.erb
            _form.html.erb
          ]

          required.each do |file|

            unless File.exist?(views.join(file))

              issues << [
                :warning,
                "Missing #{file}"
              ]

            end

          end

          Dir.glob(views.join("**/*.erb")).each do |view|

            body = File.read(view)

            if body.include?("edit_#{model.name.underscore}_path")

              issues << [
                :info,
                "#{File.basename(view)} references edit helper"
              ]

            end

            if slug_model? &&
               body.match?(/\.id\b/)

              issues << [
                :warning,
                "#{File.basename(view)} appears to use id on a slug resource"
              ]

            end

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
