module Lightek
  module Upgrades

    class Handler

      def self.apply

        raise NotImplementedError,
          "Upgrade handler must implement apply"

      end

    end

  end
end
