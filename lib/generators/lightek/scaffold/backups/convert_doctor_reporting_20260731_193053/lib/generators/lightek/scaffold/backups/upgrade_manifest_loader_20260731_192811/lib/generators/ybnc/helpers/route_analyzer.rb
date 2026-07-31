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
