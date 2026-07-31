module Lightek
  module Generators
    module DoctorRunner

      def run_doctor

        return unless File.exist?(
          File.expand_path(
            "../../../bin/lightek",
            __dir__
          )
        )

        puts
        puts "Running Lightek Doctor..."
        puts

        system(
          "bin/lightek"
        )

      end

    end
  end
end
