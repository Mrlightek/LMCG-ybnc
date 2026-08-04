module Lightek
  module Backup

    class Manifest

      attr_reader :files

      def initialize(files = [])
        @files = files
      end

      def add(file)
        files << file
      end

      def to_h
        {
          files: files
        }
      end

    end

  end
end
