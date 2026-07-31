class currentucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = current.find_by(id: id)

    result = currentucreateService.call(record)

    currentMailer.completed(result).deliver_later

    currentNotification.broadcast(result)

    currentEvent.log(result, "create")

  end

end
