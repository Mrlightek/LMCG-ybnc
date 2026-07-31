require "fileutils"
require_relative "backup/manifest"

module Lightek

  class BackupManager

    BACKUP_DIR =
      "lib/generators/lightek/scaffold/backups"

    def self.create(source, destination)

      FileUtils.mkdir_p(destination)

      manifest =
        Backup::Manifest.new

      Dir.glob("#{source}/**/*").each do |file|

        next if file.include?("/backups/")

        relative =
          file.sub("#{source}/", "")

        target =
          File.join(destination, relative)

        if File.directory?(file)

          FileUtils.mkdir_p(target)

        else

          FileUtils.mkdir_p(File.dirname(target))
          FileUtils.cp(file, target)

          manifest.add(relative)

        end

      end

      File.write(
        File.join(destination, "manifest.json"),
        JSON.pretty_generate(manifest.to_h)
      )

    end

  end

end
