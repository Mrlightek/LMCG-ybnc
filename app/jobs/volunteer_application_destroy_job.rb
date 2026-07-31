class volunteer_applicationudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = volunteer_application.find_by(id: id)

    result = volunteer_applicationudestroyService.call(record)

    volunteer_applicationMailer.completed(result).deliver_later

    volunteer_applicationNotification.broadcast(result)

    volunteer_applicationEvent.log(result, "destroy")

  end

end
