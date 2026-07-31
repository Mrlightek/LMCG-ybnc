module Lightek
  module Upgrades

    class Verifier

      def self.verify

        validator =
          Lightek::Contracts::Validator


        errors = 0


        ApplicationRecord.descendants
          .reject(&:abstract_class?)
          .each do |model|

            doctor =
              validator.new(model.name)

            doctor.validate

            issues =
              doctor.instance_variable_get(:@issues)


            errors +=
              issues.count do |issue|

                issue.level == :error

              end

          end


        errors.zero?

      rescue => e

        false

      end

    end

  end
end
