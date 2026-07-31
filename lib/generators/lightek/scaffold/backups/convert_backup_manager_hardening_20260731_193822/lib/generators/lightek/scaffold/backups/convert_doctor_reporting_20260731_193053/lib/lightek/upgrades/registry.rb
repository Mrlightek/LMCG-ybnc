module Lightek
  module Upgrades

    class Registry

      @upgrades = []

      class << self

        attr_reader :upgrades


        def register(attributes)

          @upgrades << attributes

        end


        def all

          load_manifests

          @upgrades

        end


        private


        def load_manifests

          return if @loaded

          Dir[
            File.expand_path(
              "manifests/*.rb",
              __dir__
            )
          ].sort.each do |file|

            require file

          end

          @loaded = true

        end

      end

    end

  end
end


module Lightek
  module Upgrades

    class Registry

      def self.register(attributes)

        @upgrades ||= []

        @upgrades << attributes

      end

    end

  end
end

