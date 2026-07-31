class eventuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = event.find_by(id: id)

    result = eventuupdateService.call(record)

    eventMailer.completed(result).deliver_later

    eventNotification.broadcast(result)

    eventEvent.log(result, "update")

  end

end
