class articleudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = article.find_by(id: id)

    result = articleudestroyService.call(record)

    articleMailer.completed(result).deliver_later

    articleNotification.broadcast(result)

    articleEvent.log(result, "destroy")

  end

end
