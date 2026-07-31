class eventudestroyService

  def self.call(record)
    new(record).call
  end


  def initialize(record)
    @record = record
  end


  def call

    # update business logic

    @record

  end

end
