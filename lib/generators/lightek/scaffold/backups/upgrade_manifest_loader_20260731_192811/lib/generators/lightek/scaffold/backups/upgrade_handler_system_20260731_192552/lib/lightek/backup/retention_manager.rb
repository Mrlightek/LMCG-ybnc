require "fileutils"

module Lightek
  module Backup

    class RetentionManager

      DEFAULT_LIMIT = 10

      def initialize(
        directory = "lib/generators/lightek/scaffold/backups",
        limit = DEFAULT_LIMIT
      )

        @directory = directory
        @limit = limit

      end


      def cleanup

        backups =
          Dir.glob(
            File.join(@directory, "*")
          )
          .select do |path|

            File.directory?(path) &&
              File.basename(path) != "backups"

          end
          .sort


        excess =
          backups[0...-@limit] || []


        excess.each do |backup|

          FileUtils.rm_rf(backup)

        end


        excess

      end


    end

  end
end
