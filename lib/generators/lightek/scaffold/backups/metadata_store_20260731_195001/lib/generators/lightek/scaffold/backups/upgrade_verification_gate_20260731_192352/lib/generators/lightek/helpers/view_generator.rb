module Lightek
  module Generators
    module Helpers

      class ViewGenerator


        def initialize(model)

          @model = model

        end



        def fields

          model.columns.reject do |column|

            %w[
              id
              created_at
              updated_at
            ].include?(column.name)

          end

        end




        def input_for(column)


          case column.type.to_sym


          when :text

            "text_area"


          when :boolean

            "check_box"


          when :date

            "date_field"


          when :datetime

            "datetime_field"


          when :integer

            "number_field"


          when :decimal

            "number_field"


          else

            "text_field"


          end


        end



        private


        attr_reader :model


      end

    end
  end
end
