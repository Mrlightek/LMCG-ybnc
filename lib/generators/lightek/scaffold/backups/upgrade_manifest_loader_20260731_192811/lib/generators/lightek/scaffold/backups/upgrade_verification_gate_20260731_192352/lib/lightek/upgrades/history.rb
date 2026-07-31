module Lightek
  module Upgrades

    class History

      @records = []


      class << self

        attr_reader :records


        def record(attributes)

          @records << ExecutionRecord.new(
            **attributes,
            executed_at: Time.now
          )

        end


        def all

          @records

        end


        def applied?(name, version=nil)

          @records.any? do |record|

            record.name.to_s == name.to_s &&
            (version.nil? || record.version == version) &&
            record.status.to_s == "success"

          end

        end

      end

    end

  end
end
