class skilluupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = skill.find_by(id: id)

    result = skilluupdateService.call(record)

    skillMailer.completed(result).deliver_later

    skillNotification.broadcast(result)

    skillEvent.log(result, "update")

  end

end
