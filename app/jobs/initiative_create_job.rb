class initiativeucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = initiative.find_by(id: id)

    result = initiativeucreateService.call(record)

    initiativeMailer.completed(result).deliver_later

    initiativeNotification.broadcast(result)

    initiativeEvent.log(result, "create")

  end

end
