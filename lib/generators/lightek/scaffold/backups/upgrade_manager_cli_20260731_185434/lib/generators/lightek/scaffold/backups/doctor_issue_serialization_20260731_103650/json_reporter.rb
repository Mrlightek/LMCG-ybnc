require "json"
require_relative "reporter"

module Lightek
  module Reporting

    class JsonReporter < Reporter

      def report(result)

        puts JSON.pretty_generate(result)

      end

    end

  end
end
