class currentudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = current.find_by(id: id)

    result = currentudestroyService.call(record)

    currentMailer.completed(result).deliver_later

    currentNotification.broadcast(result)

    currentEvent.log(result, "destroy")

  end

end
