require_relative "../contracts/issue"
module Lightek
  module Generators
    module Helpers

      class SchemaAnalyzer

        def initialize(model_name)
          @model = model_name.constantize
        end

        def has_column?(column)
          @model.column_names.include?(column.to_s)
        end

        def columns
          @model.column_names
        end

      end

    end
  end
end
