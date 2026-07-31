#!/bin/bash

set -e

echo "Upgrading Lightek scaffold contract..."

BASE="lib/generators/lightek"

mkdir -p "$BASE/helpers"

cat > "$BASE/helpers/schema_analyzer.rb" <<'RUBY'
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
RUBY


cat > "$BASE/helpers/route_analyzer.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class RouteAnalyzer

        def initialize(resource)
          @resource = resource.to_s
        end

        def actions
          Rails.application.routes.routes
            .select { |route| route.defaults[:controller] == @resource }
            .map { |route| route.defaults[:action] }
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


cat > "$BASE/helpers/ability_generator.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class AbilityGenerator

        def initialize(model_name)
          @model_name = model_name
        end

        def content
          <<~RUBY
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


cat > "$BASE/helpers/view_generator.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class ViewGenerator

        def initialize(model)
          @model = model
        end

        def public_crud?
          false
        end

        def admin_crud?
          true
        end

      end

    end
  end
end
RUBY


echo "Helpers created."

echo "Adding templates directory..."

mkdir -p "$BASE/scaffold/templates/abilities"

cat > "$BASE/scaffold/templates/abilities/ability.rb" <<'RUBY'
can :read, <%= class_name %>

can [:create, :update, :destroy], <%= class_name %> do |record|
  user.admin?
end
RUBY


echo "Lightek scaffold contract upgrade complete."