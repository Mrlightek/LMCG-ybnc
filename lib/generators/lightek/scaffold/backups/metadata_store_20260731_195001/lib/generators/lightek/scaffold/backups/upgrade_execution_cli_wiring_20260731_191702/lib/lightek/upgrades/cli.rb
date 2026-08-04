module Lightek
  module Upgrades

    class Cli

      def self.run(arguments)

        command = arguments.shift

        case command

        when "upgrades"

          list

        when "upgrade"

          name = arguments.shift

          unless name
            puts "Missing upgrade name."
            exit 1
          end

          puts "Upgrade execution coming next:"
          puts name

        else

          puts <<~HELP

            Lightek Upgrade Commands

            bin/lightek upgrades

            bin/lightek upgrade NAME

          HELP

        end

      end


      def self.list

        puts
        puts "======================================"
        puts " Available Lightek Upgrades"
        puts "======================================"
        puts

        Registry.all.each do |upgrade|

          puts "#{upgrade[:name]} (#{upgrade[:version]})"

        end

        puts

      end

    end

  end
end
