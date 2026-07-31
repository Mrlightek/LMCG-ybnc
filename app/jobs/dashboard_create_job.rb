class dashboarducreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = dashboard.find_by(id: id)

    result = dashboarducreateService.call(record)

    dashboardMailer.completed(result).deliver_later

    dashboardNotification.broadcast(result)

    dashboardEvent.log(result, "create")

  end

end
