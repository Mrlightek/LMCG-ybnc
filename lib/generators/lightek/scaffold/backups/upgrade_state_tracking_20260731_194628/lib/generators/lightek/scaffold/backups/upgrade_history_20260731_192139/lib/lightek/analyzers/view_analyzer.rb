require_relative "../contracts/issue"

module Lightek
  module Analyzers

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

          issues << ContractIssue.new(
            analyzer: :view,
            level: :warning,
            message: "Missing views directory",
            file: views.to_s
          )

        end


        if slug_model?

          issues << ContractIssue.new(
            analyzer: :view,
            level: :info,
            message: "Slug model detected",
            file: views.to_s
          )

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