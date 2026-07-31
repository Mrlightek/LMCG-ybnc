module Lightek
  module Generators
    module Helpers

      class SeedGenerator


        def initialize(model)

          @model = model

        end


        def ignored_columns

          %w[
            id
            created_at
            updated_at
          ]

        end



        def columns

          @model.constantize
            .columns
            .reject do |column|

              ignored_columns.include?(
                column.name
              )

            end

        end


      end

    end
  end
end
