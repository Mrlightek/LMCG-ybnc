module Lightek
  module Backup

    class SafetyGuard

      def self.safe_path?(path)

        normalized =
          File.expand_path(path)

        blocked =
          [
            "/backups/",
            "/tmp/",
            "/log/"
          ]

        blocked.none? do |entry|

          normalized.include?(entry)

        end

      end


      def self.validate!(path)

        unless safe_path?(path)

          raise(
            "Unsafe backup path detected: #{path}"
          )

        end

        true

      end

    end

  end
end
