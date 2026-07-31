
require_relative "../../../lightek/generators/doctor_runner"

require_relative "../../helpers/contract_validator"
require_relative "../../helpers/seed_generator"

require_relative "../helpers/contract_analyzer"

require "rails/generators"

require_relative "../helpers/schema_analyzer"
require_relative "../helpers/route_analyzer"
require_relative "../helpers/ability_generator"
require_relative "../helpers/view_generator"

module Lightek
  module Generators
    class ScaffoldGenerator

  include Lightek::Generators::DoctorRunner < Rails::Generators::NamedBase

      source_root File.expand_path("templates", __dir__)

      argument :attributes,
        type: :array,
        default: [],
        banner: "field:type field:type"



      def analyze_model_contract

        analyzer =
          Lightek::Generators::Helpers::ContractAnalyzer.new(
            file_name.classify
          )

        analyzer.report(self)

      end



      def create_current

        template(
          "current/current.rb",
          "app/models/current.rb"
        )

      end



      def validate_contract

        validator =
          Lightek::Generators::Helpers::ContractValidator.new(
            file_name.classify
          )

        validator.validate

      end


      def create_model
        template(
          "model.rb",
          "app/models/#{file_name}.rb"
        )
      end


      def create_services

        %w[create update destroy].each do |action|

          template(
            "service.rb",
            "app/services/#{plural_name}/#{action}_service.rb",
            { action: action }
          )

        end

      end


      def create_jobs

        template(
          "job.rb",
          "app/jobs/#{plural_name}/pipeline_job.rb"
        )

      end


      def create_mailer

        template(
          "mailer.rb",
          "app/mailers/#{plural_name}/mailer.rb"
        )

      end


      def create_notification

        template(
          "notification.rb",
          "app/notifications/#{plural_name}/notification.rb"
        )

      end


      def create_event

        template(
          "event.rb",
          "app/events/#{plural_name}/activity_event.rb"
        )

      end


      def create_controller
        template(
          "controller.rb",
          "app/controllers/#{plural_name}_controller.rb"
        )
      end



      def create_seed
        template(
          "seeds.rb",
          "db/seeds/#{plural_name}_seeds.rb"
        )

        append_to_file "db/seeds.rb",
          "\nrequire_relative \"seeds/#{plural_name}_seeds\"\n"
      end
      def create_views

        generator =
          Lightek::Generators::Helpers::ViewGenerator.new(
            file_name.classify.constantize
          )


        template(
          "views/index.html.erb",
          "app/views/#{plural_name}/index.html.erb"
        )


        template(
          "views/show.html.erb",
          "app/views/#{plural_name}/show.html.erb"
        )


        template(
          "views/_form.html.erb",
          "app/views/#{plural_name}/_form.html.erb"
        )


        template(
          "views/new.html.erb",
          "app/views/#{plural_name}/new.html.erb"
        )


        template(
          "views/edit.html.erb",
          "app/views/#{plural_name}/edit.html.erb"
        )


      end

      def analyze_contract
        model = file_name.classify

        say ""
        say "Lightek Contract Analysis"
        say "-------------------------"
        say "Model: #{model}"

        begin
          schema = Lightek::Generators::Helpers::SchemaAnalyzer.new(model)

          say "Columns:"
          schema.columns.each do |column|
            say "  ✓ #{column}"
          end

        rescue NameError
          say "  Model not loaded yet."
        end

        say ""
      end




      def create_activity_log

        template(
          "activity_log.rb",
          "app/models/activity_log.rb"
        )

        template(
          "activity_logs_migration.rb",
          "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_activity_logs.rb"
        )

      end

      def create_ability

        template(
          "abilities/ability.rb",
          "app/models/abilities/#{file_name}_ability.rb"
        )

      end

      private

      def attribute_value(attribute)

        case attribute.type.to_sym

        when :string
          "Example #{attribute.name}"

        when :text
          "Example text for #{attribute.name}"

        when :integer
          "rand(1..100)"

        when :decimal
          "rand(10.0..500.0).round(2)"

        when :float
          "rand(1.0..100.0)"

        when :boolean
          "true"

        when :references
          "#{attribute.name.camelize}.first"

        else
          "nil"

        end

      end

    end
  end
end


run_doctor
