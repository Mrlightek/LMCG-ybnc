class ExampleJob < ApplicationJob

  queue_as :default

  def perform(record_id)

    record = Example.find(record_id)

    result = ExampleService.call(record)

    ExampleMailer.completed(result).deliver_later

    ExampleNotification.broadcast(result)

    EventLog.create!(
      event_type: "example_completed",
      data: result
    )

  end

end
