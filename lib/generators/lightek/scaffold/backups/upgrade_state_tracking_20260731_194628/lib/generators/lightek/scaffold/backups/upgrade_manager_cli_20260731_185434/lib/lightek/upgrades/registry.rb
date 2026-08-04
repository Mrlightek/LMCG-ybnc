module Lightek
  module Upgrades

    class Registry

      def self.all

        [
          {
            name: "doctor_reporting",
            version: "1.0.0"
          },
          {
            name: "doctor_issue_serialization",
            version: "1.0.0"
          },
          {
            name: "backup_manager_hardening",
            version: "1.0.0"
          }
        ]

      end

    end

  end
end
