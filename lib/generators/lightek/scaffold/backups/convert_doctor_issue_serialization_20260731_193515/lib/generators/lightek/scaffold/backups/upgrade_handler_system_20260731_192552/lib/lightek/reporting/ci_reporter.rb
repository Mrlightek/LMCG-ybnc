require_relative "console_reporter"

module Lightek
  module Reporting

    class CiReporter < ConsoleReporter

      def report(result)

        super

        exit 1 unless result[:errors].zero?

      end

    end

  end
end
