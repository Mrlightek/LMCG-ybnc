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


        Result.new(
          name: upgrade[:name],
          version: upgrade[:version],
          status: :success,
          message: "Upgrade executed"
        )

      end

    end

  end
end
