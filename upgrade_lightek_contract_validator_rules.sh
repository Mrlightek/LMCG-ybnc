#!/bin/bash

set -e

echo "Upgrading Lightek Contract Validator rules..."

ROOT="lib/generators/lightek"
HELPERS="$ROOT/helpers"
SCAFFOLD="$ROOT/scaffold"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="$SCAFFOLD/backups/contract_validator_rules_upgrade_$TIMESTAMP"

echo "Creating backup..."

mkdir -p "$BACKUP"

rsync -a \
  --exclude "backups" \
  "$HELPERS/" \
  "$BACKUP/helpers/"


echo "Updating ContractValidator..."

cat > "$HELPERS/contract_validator.rb" <<'RUBY'
module Lightek
  module Generators
    module Helpers

      class ContractValidator


        attr_reader :model_name


        def initialize(model_name)

          @model_name = model_name
          @issues = []

        end



        def validate

          puts ""
          puts "Lightek Contract Validation"
          puts "=========================="
          puts "Model: #{model_name}"
          puts ""


          check_model
          check_schema
          check_routes
          check_views
          check_pipeline
          check_authorization


          report


          @issues.none? do |issue|
            issue[:level] == :error
          end

        end



        private



        def add(level, message)

          @issues << {
            level: level,
            message: message
          }

        end




        def model

          model_name.constantize

        rescue NameError

          nil

        end




        def check_model

          unless model

            add(
              :error,
              "Model #{model_name} does not exist"
            )

            return

          end


          if has_column?("slug")

            unless model.instance_methods.include?(:to_param)

              add(
                :warning,
                "Slug model should define to_param"
              )

            end

          end

        end




        def check_schema

          return unless model


          required =
            model.columns
              .select { |c| c.null == false }
              .map(&:name)



          required.each do |column|

            unless model.column_names.include?(column)

              add(
                :error,
                "Missing required column #{column}"
              )

            end

          end

        end




        def check_routes

          return unless has_column?("slug")


          add(
            :info,
            "Slug resource should use param: :slug routes"
          )


        end




        def check_views

          add(
            :info,
            "View route compatibility requires inspection"
          )

        end




        def check_pipeline

          return unless model


          hooks = model.private_instance_methods


          unless hooks.any? { |m| m.to_s.include?("pipeline") }

            add(
              :warning,
              "Model has no pipeline hooks"
            )

          end

        end




        def check_authorization

          add(
            :info,
            "Authorization contract pending controller scan"
          )

        end




        def has_column?(name)

          model &&
            model.column_names.include?(name)

        end




        def report


          if @issues.empty?

            puts "✓ Contract valid"

            return

          end



          @issues.each do |issue|

            puts "[#{issue[:level].upcase}] #{issue[:message]}"

          end


        end



      end

    end
  end
end
RUBY


echo ""
echo "Contract Validator rules upgrade complete."
echo ""
echo "Backup:"
echo "$BACKUP"