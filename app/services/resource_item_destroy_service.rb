class resource_itemudestroyService

  def self.call(record)
    new(record).call
  end


  def initialize(record)
    @record = record
  end


  def call

    # destroy business logic

    @record

  end

end
