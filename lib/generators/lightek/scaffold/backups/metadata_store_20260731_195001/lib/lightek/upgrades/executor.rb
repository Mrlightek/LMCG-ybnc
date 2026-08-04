require_relative "state"
module Lightek
  module Upgrades

    class Executor

      def initialize(name)

        @name = name

      end


      def run

        upgrade =
          Registry.all.find do |item|

            item[:name].to_s == @name.to_s

          end


        unless upgrade

          return Result.new(
            name: @name,
            status: :failed,
            message: "Upgrade not found"
          )

        end


        if State.applied?(
          upgrade[:name],
          upgrade[:version]
        )

          return Result.new(
            name: upgrade[:name],
            version: upgrade[:version],
            status: :skipped,
            message: "Already applied"
          )

        end


        if upgrade[:handler]

          applied =
            upgrade[:handler].apply

          unless applied

            raise "Upgrade handler failed"

          end

        end


        State.record(
          upgrade[:name],
          upgrade[:version]
        )


        result =
          Result.new(
            name: upgrade[:name],
            version: upgrade[:version],
            status: :success,
            message: "Upgrade handler executed"
          )


        verified =
          Verifier.verify


        if verified

          result.status = :success
          result.message = "Upgrade executed and verified"

        else

          result.status = :failed
          result.message = "Upgrade executed but verification failed"

        end


        History.record(
          name: result.name,
          version: result.version,
          status: result.status,
          message: result.message
        )


        result

      end

    end

  end
end
