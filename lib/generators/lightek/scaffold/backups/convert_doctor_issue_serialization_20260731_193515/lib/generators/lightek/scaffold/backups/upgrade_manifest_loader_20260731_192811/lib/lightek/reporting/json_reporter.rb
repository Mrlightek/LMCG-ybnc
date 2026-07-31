require "json"
require_relative "reporter"

module Lightek
  module Reporting

    class JsonReporter < Reporter

      def report(result)

        puts JSON.pretty_generate(
          {
            summary: {
              errors: result[:errors],
              warnings: result[:warnings]
            },
            issues: result[:issues]
          }
        )

      end

    end

  end
end
