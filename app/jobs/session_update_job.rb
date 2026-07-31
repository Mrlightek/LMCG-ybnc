class sessionuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = session.find_by(id: id)

    result = sessionuupdateService.call(record)

    sessionMailer.completed(result).deliver_later

    sessionNotification.broadcast(result)

    sessionEvent.log(result, "update")

  end

end
