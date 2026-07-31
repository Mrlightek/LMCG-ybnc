class resource_itemucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = resource_item.find_by(id: id)

    result = resource_itemucreateService.call(record)

    resource_itemMailer.completed(result).deliver_later

    resource_itemNotification.broadcast(result)

    resource_itemEvent.log(result, "create")

  end

end
