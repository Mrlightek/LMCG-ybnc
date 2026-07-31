class articleuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = article.find_by(id: id)

    result = articleuupdateService.call(record)

    articleMailer.completed(result).deliver_later

    articleNotification.broadcast(result)

    articleEvent.log(result, "update")

  end

end
