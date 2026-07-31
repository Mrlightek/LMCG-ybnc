module Ybnc
  module Generators
    module Helpers

      class ViewGenerator

        def initialize(model)
          @model = model
        end

        def public_view?
          true
        end

        def admin_view?
          true
        end

      end

    end
  end
end
