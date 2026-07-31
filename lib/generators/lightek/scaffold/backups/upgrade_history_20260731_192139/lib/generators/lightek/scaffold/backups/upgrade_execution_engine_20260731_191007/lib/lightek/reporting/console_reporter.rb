require_relative "reporter"

module Lightek
  module Reporting

    class ConsoleReporter < Reporter

      def report(result)

        puts
        puts "======================================"
        puts "Summary"
        puts "======================================"

        puts "Errors   : #{result[:errors]}"
        puts "Warnings : #{result[:warnings]}"

        puts

        if result[:errors].zero?
          puts "✓ Contract validation passed."
        else
          puts "✗ Contract validation failed."
        end

      end

    end

  end
end
