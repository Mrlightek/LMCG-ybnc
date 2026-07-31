class skilludestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = skill.find_by(id: id)

    result = skilludestroyService.call(record)

    skillMailer.completed(result).deliver_later

    skillNotification.broadcast(result)

    skillEvent.log(result, "destroy")

  end

end
