class resource_itemudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = resource_item.find_by(id: id)

    result = resource_itemudestroyService.call(record)

    resource_itemMailer.completed(result).deliver_later

    resource_itemNotification.broadcast(result)

    resource_itemEvent.log(result, "destroy")

  end

end
