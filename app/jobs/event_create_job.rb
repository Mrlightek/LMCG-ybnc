class eventucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = event.find_by(id: id)

    result = eventucreateService.call(record)

    eventMailer.completed(result).deliver_later

    eventNotification.broadcast(result)

    eventEvent.log(result, "create")

  end

end
