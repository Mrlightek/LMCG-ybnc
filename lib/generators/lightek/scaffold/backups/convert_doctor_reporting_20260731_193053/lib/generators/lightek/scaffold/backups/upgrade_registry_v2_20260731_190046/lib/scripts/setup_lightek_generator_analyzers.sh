#!/bin/bash

set -e

echo "Setting up Lightek generator analyzers..."

BASE="lib/generators/ybnc/helpers"

mkdir -p "$BASE"

cat > "$BASE/schema_analyzer.rb" <<'RUBY'
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
RUBY


cat > "$BASE/route_analyzer.rb" <<'RUBY'
module Ybnc
  module Generators
    module Helpers

      class RouteAnalyzer

        def initialize(resource)
          @resource = resource.to_s
        end

        def public_crud?
          routes.any? do |route|
            route.defaults[:controller] == @resource
          end
        end

        def routes
          Rails.application.routes.routes
        end

        def actions
          routes
            .select { |r| r.defaults[:controller] == @resource }
            .map { |r| r.defaults[:action] }
            .compact
            .uniq
        end

        def can_edit?
          actions.include?("edit")
        end

        def can_destroy?
          actions.include?("destroy")
        end

      end

    end
  end
end
RUBY


cat > "$BASE/ability_generator.rb" <<'RUBY'
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
RUBY


cat > "$BASE/view_generator.rb" <<'RUBY'
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
RUBY


echo "Analyzers created:"
echo "$BASE"
ls "$BASE"

echo "Done."