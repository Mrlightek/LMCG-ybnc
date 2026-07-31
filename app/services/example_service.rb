class ExampleService < ApplicationService

  def initialize(record)
    @record = record
  end


  def call

    # Business logic here

    @record

  end


end
