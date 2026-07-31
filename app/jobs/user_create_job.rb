class userucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = user.find_by(id: id)

    result = userucreateService.call(record)

    userMailer.completed(result).deliver_later

    userNotification.broadcast(result)

    userEvent.log(result, "create")

  end

end
