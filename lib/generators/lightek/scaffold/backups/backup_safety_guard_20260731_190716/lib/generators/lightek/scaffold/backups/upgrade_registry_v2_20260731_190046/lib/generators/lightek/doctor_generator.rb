require "rails/generators"

module Lightek
  module Generators

    class DoctorGenerator < Rails::Generators::Base

      source_root File.expand_path(
        "templates",
        __dir__
      )

      def run

        system(
          "bin/lightek"
        )

      end

    end

  end
end
