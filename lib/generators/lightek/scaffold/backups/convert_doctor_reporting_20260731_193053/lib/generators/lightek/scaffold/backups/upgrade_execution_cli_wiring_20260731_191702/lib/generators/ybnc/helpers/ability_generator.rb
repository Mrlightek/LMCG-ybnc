module Ybnc
  module Generators
    module Helpers

      class AbilityGenerator

        def initialize(model_name)
          @model_name = model_name
        end

        def generate
          <<~RUBY
            # #{@model_name} permissions

            can :read, #{@model_name}

            can [:create, :update, :destroy], #{@model_name} do |record|
              user.admin?
            end
          RUBY
        end

      end

    end
  end
end
