class initiativeuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = initiative.find_by(id: id)

    result = initiativeuupdateService.call(record)

    initiativeMailer.completed(result).deliver_later

    initiativeNotification.broadcast(result)

    initiativeEvent.log(result, "update")

  end

end
