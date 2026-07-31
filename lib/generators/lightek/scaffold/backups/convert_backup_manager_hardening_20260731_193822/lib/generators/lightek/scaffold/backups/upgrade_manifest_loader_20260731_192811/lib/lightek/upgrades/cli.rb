module Lightek
  module Upgrades

    class Cli

      def self.run(arguments)

        command = arguments.shift


        case command

        when "upgrades"

          list


        when "upgrade"

          execute(arguments.shift)


        else

          help

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


      def self.execute(name)

        unless name

          puts "Missing upgrade name."
          exit 1

        end


        result =
          Executor.new(name).run


        puts
        puts "======================================"
        puts " Lightek Upgrade"
        puts "======================================"
        puts

        puts "Upgrade: #{result.name}"
        puts "Version: #{result.version}" if result.version
        puts "Status: #{result.status}"
        puts "Message: #{result.message}"

        puts

        exit 1 if result.status == :failed

      end


      def self.help

        puts <<~HELP

          Lightek Upgrade Commands

          bin/lightek upgrades

          bin/lightek upgrade NAME

        HELP

      end

    end

  end
end
