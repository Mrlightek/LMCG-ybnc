class contact_messageucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = contact_message.find_by(id: id)

    result = contact_messageucreateService.call(record)

    contact_messageMailer.completed(result).deliver_later

    contact_messageNotification.broadcast(result)

    contact_messageEvent.log(result, "create")

  end

end
