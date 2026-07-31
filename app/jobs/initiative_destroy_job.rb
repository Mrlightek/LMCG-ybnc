class initiativeudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = initiative.find_by(id: id)

    result = initiativeudestroyService.call(record)

    initiativeMailer.completed(result).deliver_later

    initiativeNotification.broadcast(result)

    initiativeEvent.log(result, "destroy")

  end

end
