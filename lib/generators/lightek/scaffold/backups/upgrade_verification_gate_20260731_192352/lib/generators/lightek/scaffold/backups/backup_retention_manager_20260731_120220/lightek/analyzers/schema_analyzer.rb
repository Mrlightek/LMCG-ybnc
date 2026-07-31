require_relative "../contracts/issue"

module Lightek
  module Analyzers

    class SchemaAnalyzer

      attr_reader :model


      def initialize(model)

        @model = model

      end


      def validate

        issues = []

        model.columns.each do |column|

          if column.null == false &&
             !column.name.in?(%w[
               id
               created_at
               updated_at
             ])

            issues << ContractIssue.new(
              analyzer: :schema,
              level: :info,
              message: "Required column detected: #{column.name}",
              file: model.table_name
            )

          end

        end


        issues

      end


    end

  end
end
