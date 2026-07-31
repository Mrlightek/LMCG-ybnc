module Ybnc
  module Generators
    module Helpers

      class SchemaAnalyzer

        def initialize(model_name)
          @model = model_name.constantize
        end

        def has_column?(column)
          @model.column_names.include?(column.to_s)
        end

        def has_association?(association)
          @model.reflect_on_association(association).present?
        end

        def columns
          @model.column_names
        end

        def model
          @model
        end

      end

    end
  end
end
