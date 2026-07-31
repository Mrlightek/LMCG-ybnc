class eventudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = event.find_by(id: id)

    result = eventudestroyService.call(record)

    eventMailer.completed(result).deliver_later

    eventNotification.broadcast(result)

    eventEvent.log(result, "destroy")

  end

end
