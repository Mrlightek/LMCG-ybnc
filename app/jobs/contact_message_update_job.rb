class contact_messageuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = contact_message.find_by(id: id)

    result = contact_messageuupdateService.call(record)

    contact_messageMailer.completed(result).deliver_later

    contact_messageNotification.broadcast(result)

    contact_messageEvent.log(result, "update")

  end

end
