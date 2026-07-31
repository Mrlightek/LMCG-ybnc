module Lightek
  module Generators
    module Helpers

      class BackupManager


        def self.create(source, destination)

          FileUtils.mkdir_p(destination)


          FileUtils.cp_r(
            Dir[
              "#{source}/**/*"
            ].reject do |file|

              file.include?("/backups/")

            end,
            destination
          )

        end


      end

    end
  end
end
