class userudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = user.find_by(id: id)

    result = userudestroyService.call(record)

    userMailer.completed(result).deliver_later

    userNotification.broadcast(result)

    userEvent.log(result, "destroy")

  end

end
