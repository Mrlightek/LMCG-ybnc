module Lightek
  module Testing

    class GeneratorValidation

      attr_reader :results


      def initialize

        @results = []

      end


      def check(path)

        unless File.exist?(path)

          @results << {
            level: :error,
            message: "Generated artifact missing: #{path}"
          }

          return false

        end


        @results << {
          level: :success,
          message: "Generated artifact exists: #{path}"
        }

        true

      end


      def passed?

        @results.none? do |result|

          result[:level] == :error

        end

      end


    end

  end
end
