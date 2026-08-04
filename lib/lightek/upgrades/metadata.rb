module Lightek
  module Upgrades

    class Metadata

      ROOT =
        File.expand_path(
          ".lightek",
          Dir.pwd
        )


      def self.ensure!

        Dir.mkdir(ROOT) unless Dir.exist?(ROOT)

      end


      def self.file(name)

        ensure!

        File.join(
          ROOT,
          name
        )

      end

    end

  end
end
