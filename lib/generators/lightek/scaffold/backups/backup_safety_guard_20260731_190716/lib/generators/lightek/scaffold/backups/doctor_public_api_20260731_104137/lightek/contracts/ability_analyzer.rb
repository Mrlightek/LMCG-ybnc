require_relative "issue"

module Lightek
  module Contracts

      class AbilityAnalyzer

        attr_reader :model

        def initialize(model)
          @model = model
        end

        def validate

          issues = []

          check_ability_file(issues)
          check_controller_authorize(issues)

          issues

        end

        private

        def check_ability_file(issues)

          file =
            Rails.root.join(
              "app/models/abilities/#{model.name.underscore}_ability.rb"
            )

          unless File.exist?(file)

            issues << ContractIssue.new(
              analyzer: :ability,
              level: :warning,
              message: "Missing ability file",
              file: file.to_s
            )

          end

        end

        def check_controller_authorize(issues)

          controller =
            Rails.root.join(
              "app/controllers/#{model.name.underscore.pluralize}_controller.rb"
            )

          return unless File.exist?(controller)

          body = File.read(controller)

          unless body.include?("authorize!")

            issues << ContractIssue.new(
              analyzer: :ability,
              level: :warning,
              message: "Controller does not invoke authorize!",
              file: controller.to_s
            )

          end

        end

      end

    end
  end
