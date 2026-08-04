module Lightek
  module Upgrades

    class State

      FILE =
        File.expand_path(
          "upgrade_state.yml",
          Dir.pwd
        )


      def self.applied

        return {} unless File.exist?(FILE)

        YAML.load_file(FILE) || {}

      end


      def self.applied?(name, version)

        applied[name] == version.to_s

      end


      def self.record(name, version)

        data = applied

        data[name] = version.to_s

        File.write(
          FILE,
          data.to_yaml
        )

      end

    end

  end
end
