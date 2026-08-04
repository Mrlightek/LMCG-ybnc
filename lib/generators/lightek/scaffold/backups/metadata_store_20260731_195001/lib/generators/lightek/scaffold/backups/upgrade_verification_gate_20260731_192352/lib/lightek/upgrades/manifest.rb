require "json"

module Lightek
  module Upgrades

    class Manifest

      PATH =
        "tmp/lightek_upgrades.json"


      def self.write(data)

        FileUtils.mkdir_p(
          File.dirname(PATH)
        )

        File.write(
          PATH,
          JSON.pretty_generate(data)
        )

      end


      def self.read

        return [] unless File.exist?(PATH)

        JSON.parse(
          File.read(PATH)
        )

      end

    end

  end
end
