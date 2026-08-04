module Lightek
  module Upgrades

    class Upgrade

      attr_reader :name, :version

      def initialize(name:, version:)
        @name = name
        @version = version
      end

    end

  end
end
