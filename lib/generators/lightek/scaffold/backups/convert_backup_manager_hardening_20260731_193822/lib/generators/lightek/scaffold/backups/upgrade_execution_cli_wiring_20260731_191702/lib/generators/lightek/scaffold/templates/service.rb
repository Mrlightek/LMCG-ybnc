module <%= class_name.pluralize %>

  class <%= action.capitalize %>Service


    def self.call(actor:, record:)

      new(
        actor: actor,
        record: record
      ).call

    end



    def initialize(actor:, record:)

      @actor = actor
      @record = record

    end



    def call

      # <%= action.capitalize %> business logic

      record

    end



    private


    attr_reader :actor, :record


  end

end
