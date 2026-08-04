module Lightek
  module Upgrades

    class Loader

      def self.load_manifests

        manifest_path =
          File.expand_path(
            "manifests/*.rb",
            __dir__
          )


        Dir[manifest_path].each do |file|

          require file

        end

      end


      def self.load_handlers

        handler_path =
          File.expand_path(
            "handlers/*.rb",
            __dir__
          )


        Dir[handler_path].each do |file|

          require file

        end

      end


      def self.load!

        load_handlers
        load_manifests

      end

    end

  end
end
