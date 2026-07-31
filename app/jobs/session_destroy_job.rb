class sessionudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = session.find_by(id: id)

    result = sessionudestroyService.call(record)

    sessionMailer.completed(result).deliver_later

    sessionNotification.broadcast(result)

    sessionEvent.log(result, "destroy")

  end

end
